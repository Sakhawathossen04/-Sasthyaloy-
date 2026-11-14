-- ==============================================================================
-- স্বাস্থ্যালয় (Sasthyaloy) - Realistic Seed Data
-- ==============================================================================

-- 1. SPECIALITIES
INSERT INTO specialities (id, code, name_bn, name_en, icon_name, description_bn, description_en) VALUES
('b1111111-1111-1111-1111-111111111111', 'cardiology', 'কার্ডিওলজিস্ট', 'Cardiologist', 'favorite', 'হৃদরোগ ও রক্তচাপ বিশেষজ্ঞ', 'Heart, blood pressure and cardiovascular disorders'),
('b2222222-2222-2222-2222-222222222222', 'medicine', 'জেনারেল মেডিসিন', 'General Medicine', 'healing', 'সাধারণ রোগ ও শারীরিক সমস্যা', 'Internal medicine and general health'),
('b3333333-3333-3333-3333-333333333333', 'pediatrics', 'শিশু বিশেষজ্ঞ', 'Pediatrician', 'child_care', 'নবজাতক ও শিশু স্বাস্থ্য সেবা', 'Infant and child wellness care'),
('b4444444-4444-4444-4444-444444444444', 'neurology', 'নিউরোলজি', 'Neurologist', 'psychology', 'মস্তিষ্ক ও স্নায়ুতন্ত্রের চিকিৎসা', 'Brain, nerve and stroke disorders'),
('b5555555-5555-5555-5555-555555555555', 'orthopedics', 'অর্থোপেডিকস', 'Orthopedics', 'accessibility_new', 'হাড় ও জয়েন্ট ব্যথা চিকিৎসা', 'Bones, joints and fractures'),
('b6666666-6666-6666-6666-666666666666', 'dermatology', 'ডার্মাটোলজিস্ট', 'Dermatologist', 'face', 'চর্ম ও যৌন রোগ বিশেষজ্ঞ', 'Skin, hair and allergy care')
ON CONFLICT (code) DO NOTHING;

-- 2. HOSPITALS (With PostGIS Point Coordinates in Dhaka)
INSERT INTO clinics_hospitals (id, name_bn, name_en, address_bn, address_en, city, contact_phone, emergency_phone, location, rating, total_beds, icu_beds_available) VALUES
('c1111111-1111-1111-1111-111111111111', 'স্কয়ার হসপিটাল লিমিটেড', 'Square Hospital Ltd.', '১৮/এফ, পশ্চিম পান্থপথ, ঢাকা-১২০৫', '18/F, West Panthapath, Dhaka-1205', 'Dhaka', '028144400', '10616', ST_SetSRID(ST_MakePoint(90.3816, 23.7531), 4326), 4.9, 400, 24),
('c2222222-2222-2222-2222-222222222222', 'এভারকেয়ার হসপিটাল ঢাকা', 'Evercare Hospital Dhaka', 'প্লট-৮১, ব্লক-ই, বসুন্ধরা আ/এ, ঢাকা', 'Plot-81, Block-E, Bashundhara R/A, Dhaka', 'Dhaka', '028431661', '10678', ST_SetSRID(ST_MakePoint(90.4318, 23.8093), 4326), 4.8, 425, 30),
('c3333333-3333-3333-3333-333333333333', 'ইউনাইটেড হসপিটাল লিমিটেড', 'United Hospital Ltd.', 'প্লট ১৫, রোড ৭১, গুলশান-২, ঢাকা', 'Plot 15, Road 71, Gulshan-2, Dhaka', 'Dhaka', '028836000', '10666', ST_SetSRID(ST_MakePoint(90.4150, 23.7977), 4326), 4.8, 500, 22),
('c4444444-4444-4444-4444-444444444444', 'বঙ্গবন্ধু শেখ মুজিব মেডিকেল বিশ্ববিদ্যালয় (বিএসএমএমইউ)', 'BSMMU (PG Hospital)', 'শাহবাগ, ঢাকা-১০০০', 'Shahbagh, Dhaka-1000', 'Dhaka', '029661051', '16263', ST_SetSRID(ST_MakePoint(90.3957, 23.7388), 4326), 4.7, 1200, 45)
ON CONFLICT (id) DO NOTHING;

-- 3. DOCTORS
INSERT INTO doctors (id, bmdc_number, title_bn, title_en, full_name_bn, full_name_en, speciality_id, hospital_id, qualifications, experience_years, consultation_fee, teleconsult_fee, rating, reviews_count) VALUES
('d1111111-1111-1111-1111-111111111111', 'BMDC-A-42981', 'অধ্যাপক ডা.', 'Prof. Dr.', 'তানভীর আহমেদ', 'Tanvir Ahmed', 'b1111111-1111-1111-1111-111111111111', 'c1111111-1111-1111-1111-111111111111', 'MBBS, FCPS (Cardiology), FACC (USA)', 18, 1200, 800, 4.9, 320),
('d2222222-2222-2222-2222-222222222222', 'BMDC-A-51029', 'ডা.', 'Dr.', 'ফারহানা চৌধুরী', 'Farhana Chowdhury', 'b3333333-3333-3333-3333-333333333333', 'c2222222-2222-2222-2222-222222222222', 'MBBS, DCH, MD (Child Health)', 12, 1000, 700, 4.8, 215),
('d3333333-3333-3333-3333-333333333333', 'ডা.', 'Dr.', 'মাহমুদুল হাসান', 'Mahmudul Hasan', 'b2222222-2222-2222-2222-222222222222', 'c3333333-3333-3333-3333-333333333333', 'MBBS, BCS (Health), FCPS (Medicine)', 15, 1000, 600, 4.9, 180),
('d4444444-4444-4444-4444-444444444444', 'অধ্যাপক ডা.', 'Prof. Dr.', 'সায়মা রহমান', 'Sayma Rahman', 'b4444444-4444-4444-4444-444444444444', 'c4444444-4444-4444-4444-444444444444', 'MBBS, MD (Neurology), Fellow (Singapore)', 20, 1500, 1000, 4.9, 410)
ON CONFLICT (id) DO NOTHING;

-- 4. DEFAULT DEMO USER & PROFILE
INSERT INTO users (id, phone_number, email, full_name, role, preferred_language) VALUES
('u1111111-1111-1111-1111-111111111111', '+8801712345678', 'sakhawat.hossen@sasthyaloy.bd', 'মো. সাখাওয়াত হোসেন (Md. Sakhawat Hossen)', 'PATIENT', 'bn')
ON CONFLICT (phone_number) DO NOTHING;

INSERT INTO user_profiles (user_id, date_of_birth, gender, blood_group, height_cm, weight_kg, allergies, chronic_conditions, emergency_contact_name, emergency_contact_phone) VALUES
('u1111111-1111-1111-1111-111111111111', '1995-08-15', 'MALE', 'B+', 172.5, 68.0, ARRAY['Penicillin', 'Dust'], ARRAY['Mild Asthma'], 'মোসা. রহিমা বেগম', '+8801812345678')
ON CONFLICT (user_id) DO NOTHING;
