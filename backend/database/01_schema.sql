-- ==============================================================================
-- স্বাস্থ্যালয় (Sasthyaloy) - Enterprise Healthcare Platform Database Schema
-- Database: PostgreSQL 16 with PostGIS Spatial Extensions
-- ==============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- 2. USERS & ROLES
CREATE TYPE user_role AS ENUM ('PATIENT', 'DOCTOR', 'CLINIC_ADMIN', 'SUPER_ADMIN');
CREATE TYPE preferred_lang AS ENUM ('bn', 'en');

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    avatar_url TEXT,
    role user_role DEFAULT 'PATIENT',
    preferred_language preferred_lang DEFAULT 'bn',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    date_of_birth DATE,
    gender VARCHAR(15), -- 'MALE', 'FEMALE', 'OTHER'
    blood_group VARCHAR(5), -- 'A+', 'B+', 'AB+', 'O+', etc.
    height_cm NUMERIC(5,2),
    weight_kg NUMERIC(5,2),
    allergies TEXT[] DEFAULT '{}',
    chronic_conditions TEXT[] DEFAULT '{}',
    emergency_contact_name VARCHAR(150),
    emergency_contact_phone VARCHAR(20),
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS family_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    primary_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    full_name VARCHAR(150) NOT NULL,
    relationship VARCHAR(50) NOT NULL, -- 'FATHER', 'MOTHER', 'SPOUSE', 'CHILD'
    gender VARCHAR(15),
    date_of_birth DATE,
    blood_group VARCHAR(5),
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. CLINICS, HOSPITALS & POSTGIS SPATIAL DIRECTORY
CREATE TABLE IF NOT EXISTS clinics_hospitals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_bn VARCHAR(255) NOT NULL,
    name_en VARCHAR(255) NOT NULL,
    address_bn TEXT NOT NULL,
    address_en TEXT NOT NULL,
    city VARCHAR(100) DEFAULT 'Dhaka',
    contact_phone VARCHAR(20) NOT NULL,
    emergency_phone VARCHAR(20) NOT NULL,
    location GEOGRAPHY(Point, 4326) NOT NULL, -- PostGIS Latitude/Longitude
    is_verified BOOLEAN DEFAULT TRUE,
    total_beds INT DEFAULT 100,
    icu_beds_available INT DEFAULT 5,
    rating NUMERIC(2,1) DEFAULT 4.8,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_clinics_location ON clinics_hospitals USING GIST (location);

-- 4. MEDICAL SPECIALITIES
CREATE TABLE IF NOT EXISTS specialities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(50) UNIQUE NOT NULL,
    name_bn VARCHAR(100) NOT NULL,
    name_en VARCHAR(100) NOT NULL,
    icon_name VARCHAR(50) NOT NULL,
    description_bn TEXT,
    description_en TEXT
);

-- 5. DOCTORS & CHAMBER SLOTS
CREATE TABLE IF NOT EXISTS doctors (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    bmdc_number VARCHAR(50) UNIQUE NOT NULL, -- BMDC Registration
    title_bn VARCHAR(50) DEFAULT 'ডা.',
    title_en VARCHAR(50) DEFAULT 'Dr.',
    full_name_bn VARCHAR(150) NOT NULL,
    full_name_en VARCHAR(150) NOT NULL,
    speciality_id UUID NOT NULL REFERENCES specialities(id) ON DELETE RESTRICT,
    hospital_id UUID REFERENCES clinics_hospitals(id) ON DELETE SET NULL,
    qualifications VARCHAR(255) NOT NULL, -- 'MBBS, FCPS, MD'
    experience_years INT DEFAULT 10,
    consultation_fee INT NOT NULL DEFAULT 800,
    teleconsult_fee INT NOT NULL DEFAULT 600,
    rating NUMERIC(2,1) DEFAULT 4.9,
    reviews_count INT DEFAULT 150,
    is_available_online BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_doctors_speciality ON doctors(speciality_id);
CREATE INDEX IF NOT EXISTS idx_doctors_hospital ON doctors(hospital_id);

CREATE TABLE IF NOT EXISTS doctor_schedules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
    day_of_week INT NOT NULL, -- 0 = Sunday, 1 = Monday, ... 6 = Saturday
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    slot_duration_minutes INT DEFAULT 15,
    max_patients INT DEFAULT 20,
    is_video_consult BOOLEAN DEFAULT FALSE
);

-- 6. APPOINTMENTS & RESERVATIONS
CREATE TYPE appointment_status AS ENUM ('PENDING', 'CONFIRMED', 'IN_CONSULTATION', 'COMPLETED', 'CANCELLED');
CREATE TYPE consultation_mode AS ENUM ('IN_PERSON_CHAMBER', 'TELECONSULT_VIDEO');

CREATE TABLE IF NOT EXISTS appointments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    serial_number VARCHAR(30) UNIQUE NOT NULL,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    patient_name VARCHAR(150) NOT NULL,
    doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE RESTRICT,
    clinic_id UUID REFERENCES clinics_hospitals(id) ON DELETE SET NULL,
    appointment_date DATE NOT NULL,
    appointment_time VARCHAR(20) NOT NULL,
    consultation_type consultation_mode NOT NULL,
    status appointment_status DEFAULT 'CONFIRMED',
    fee INT NOT NULL,
    is_paid BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_appointments_user ON appointments(user_id);
CREATE INDEX IF NOT EXISTS idx_appointments_doctor ON appointments(doctor_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(appointment_date);

-- 7. PAYMENTS & TRANSACTIONS (bKash, Nagad, Cards)
CREATE TYPE payment_gateway AS ENUM ('bKash', 'Nagad', 'Card');
CREATE TYPE payment_status AS ENUM ('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED');

CREATE TABLE IF NOT EXISTS payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id VARCHAR(50) UNIQUE NOT NULL,
    appointment_id UUID NOT NULL REFERENCES appointments(id) ON DELETE RESTRICT,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    payment_method payment_gateway NOT NULL,
    doctor_fee INT NOT NULL,
    platform_fee INT DEFAULT 50,
    total_amount INT NOT NULL,
    status payment_status DEFAULT 'SUCCESS',
    gateway_response JSONB,
    paid_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 8. WEBRTC TELECONSULTATION SESSIONS
CREATE TYPE teleconsult_status AS ENUM ('WAITING', 'ACTIVE', 'FINISHED', 'TERMINATED');

CREATE TABLE IF NOT EXISTS teleconsult_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appointment_id UUID UNIQUE NOT NULL REFERENCES appointments(id) ON DELETE CASCADE,
    room_id VARCHAR(64) UNIQUE NOT NULL,
    doctor_peer_id VARCHAR(64),
    patient_peer_id VARCHAR(64),
    status teleconsult_status DEFAULT 'WAITING',
    duration_seconds INT DEFAULT 0,
    started_at TIMESTAMPTZ,
    ended_at TIMESTAMPTZ
);

-- 9. ELECTRONIC HEALTH RECORDS (EHR): PRESCRIPTIONS & MEDICATIONS
CREATE TABLE IF NOT EXISTS prescriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appointment_id UUID REFERENCES appointments(id) ON DELETE SET NULL,
    doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE RESTRICT,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    diagnosis_bn TEXT NOT NULL,
    diagnosis_en TEXT NOT NULL,
    clinical_notes TEXT,
    follow_up_date DATE,
    is_signed BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS prescription_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    prescription_id UUID NOT NULL REFERENCES prescriptions(id) ON DELETE CASCADE,
    medicine_name VARCHAR(150) NOT NULL,
    generic_name VARCHAR(150),
    dosage VARCHAR(50) NOT NULL, -- '1+0+1', '১টি করে দিনে ২ বার'
    instruction VARCHAR(100), -- 'খাবারের পর (After meal)'
    duration_days INT DEFAULT 7
);

-- 10. LAB REPORTS & VITAL SIGNS TRACKING
CREATE TABLE IF NOT EXISTS lab_reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    report_title VARCHAR(150) NOT NULL,
    diagnostic_center VARCHAR(150) NOT NULL,
    test_date DATE NOT NULL,
    pdf_url TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'Normal',
    abnormal_params_count INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS vital_signs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    blood_pressure_sys INT, -- 120
    blood_pressure_dia INT, -- 80
    blood_glucose_fasting NUMERIC(4,1), -- 5.8 mmol/L
    pulse_rate INT, -- 72 bpm
    oxygen_spo2 INT, -- 99 %
    recorded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 11. BILINGUAL VOICE AI TRIAGE LOGS
CREATE TABLE IF NOT EXISTS ai_voice_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    transcribed_query TEXT NOT NULL,
    detected_language VARCHAR(5) DEFAULT 'bn',
    is_emergency BOOLEAN DEFAULT FALSE,
    detected_symptoms TEXT[],
    suggested_speciality VARCHAR(100),
    action_taken VARCHAR(100), -- 'EMERGENCY_INTERCEPTION_999', 'SPECIALIST_REFERRAL', 'HOME_CARE'
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 12. POSTGIS PROXIMITY STORED PROCEDURE
-- Find nearest hospitals within radius (meters) using ST_DWithin
CREATE OR REPLACE FUNCTION get_nearest_hospitals(
    lat DOUBLE PRECISION,
    lon DOUBLE PRECISION,
    radius_meters DOUBLE PRECISION DEFAULT 10000
)
RETURNS TABLE (
    id UUID,
    name_bn VARCHAR,
    name_en VARCHAR,
    address_bn TEXT,
    contact_phone VARCHAR,
    emergency_phone VARCHAR,
    distance_km DOUBLE PRECISION
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.id,
        c.name_bn,
        c.name_en,
        c.address_bn,
        c.contact_phone,
        c.emergency_phone,
        ROUND((ST_Distance(c.location, ST_SetSRID(ST_MakePoint(lon, lat), 4326)) / 1000.0)::numeric, 2)::double precision AS distance_km
    FROM clinics_hospitals c
    WHERE ST_DWithin(c.location, ST_SetSRID(ST_MakePoint(lon, lat), 4326), radius_meters)
    ORDER BY distance_km ASC;
END;
$$ LANGUAGE plpgsql;
