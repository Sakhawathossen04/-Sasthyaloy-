require('dotenv').config();
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const app = express();
const server = http.createServer(app);

// WebRTC Signaling Socket Server
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(morgan('combined'));

// In-Memory Store & Database Mock Bridge
const DB = {
  doctors: [
    {
      id: 'doc_1',
      nameBn: 'অধ্যাপক ডা. তানভীর আহমেদ',
      nameEn: 'Prof. Dr. Tanvir Ahmed',
      specialityBn: 'কার্ডিওলজিস্ট',
      specialityEn: 'Cardiologist',
      qualifications: 'MBBS, FCPS (Cardiology), FACC (USA)',
      hospitalBn: 'স্কয়ার হসপিটাল লিমিটেড',
      hospitalEn: 'Square Hospital Ltd.',
      experienceYears: 18,
      consultationFee: 1200,
      teleconsultFee: 800,
      rating: 4.9,
      isAvailableOnline: true
    },
    {
      id: 'doc_2',
      nameBn: 'ডা. ফারহানা চৌধুরী',
      nameEn: 'Dr. Farhana Chowdhury',
      specialityBn: 'শিশু বিশেষজ্ঞ',
      specialityEn: 'Pediatrician',
      qualifications: 'MBBS, DCH, MD (Child Health)',
      hospitalBn: 'এভারকেয়ার হসপিটাল ঢাকা',
      hospitalEn: 'Evercare Hospital Dhaka',
      experienceYears: 12,
      consultationFee: 1000,
      teleconsultFee: 700,
      rating: 4.8,
      isAvailableOnline: true
    }
  ],
  appointments: [],
  payments: []
};

// ==========================================
// REST API ENDPOINTS
// ==========================================

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'UP',
    platform: 'Sasthyaloy Healthcare API',
    version: '1.0.0',
    timestamp: new Date().toISOString()
  });
});

// 1. Auth: Request OTP
app.post('/api/v1/auth/request-otp', (req, res) => {
  const { phoneNumber } = req.body;
  if (!phoneNumber) {
    return res.status(400).json({ error: 'Phone number is required' });
  }

  // Generate 6 digit OTP (Demo: fixed to 123456 or random)
  const otp = '123456';
  return res.json({
    success: true,
    message: 'OTP sent successfully to ' + phoneNumber,
    expiresInSeconds: 300,
    demoOtp: otp
  });
});

// 2. Auth: Verify OTP
app.post('/api/v1/auth/verify-otp', (req, res) => {
  const { phoneNumber, otp } = req.body;
  if (otp !== '123456') {
    return res.status(401).json({ error: 'Invalid or expired OTP' });
  }

  return res.json({
    success: true,
    token: 'jwt-sasthyaloy-session-' + Date.now(),
    user: {
      id: 'u1111111-1111-1111-1111-111111111111',
      phoneNumber,
      fullName: 'মো. সাখাওয়াত হোসেন (Md. Sakhawat Hossen)',
      role: 'PATIENT',
      preferredLanguage: 'bn'
    }
  });
});

// 3. Doctors List
app.get('/api/v1/doctors', (req, res) => {
  const { speciality, search } = req.query;
  let results = [...DB.doctors];

  if (speciality) {
    results = results.filter(d => 
      d.specialityEn.toLowerCase().includes(speciality.toLowerCase()) ||
      d.specialityBn.includes(speciality)
    );
  }

  if (search) {
    results = results.filter(d => 
      d.nameEn.toLowerCase().includes(search.toLowerCase()) ||
      d.nameBn.includes(search)
    );
  }

  res.json({ success: true, count: results.length, data: results });
});

// 4. Book Appointment
app.post('/api/v1/appointments', (req, res) => {
  const { doctorId, patientName, date, time, isVideo, fee } = req.body;
  const serialNumber = '#SL-' + (1000 + DB.appointments.length + 1);

  const newAppointment = {
    id: 'apt_' + Date.now(),
    serialNumber,
    doctorId,
    patientName: patientName || 'Md. Sakhawat Hossen',
    date: date || 'Tomorrow',
    time: time || '10:30 AM',
    isVideo: Boolean(isVideo),
    fee: fee || 800,
    status: 'CONFIRMED',
    isPaid: false,
    createdAt: new Date().toISOString()
  };

  DB.appointments.push(newAppointment);
  res.status(201).json({ success: true, appointment: newAppointment });
});

// 5. Payments: bKash / Nagad Checkout
app.post('/api/v1/payments/checkout', (req, res) => {
  const { appointmentId, paymentMethod, amount } = req.body;
  const randomTrx = 'TRX-' + (paymentMethod || 'BKASH').toUpperCase() + Math.floor(100000 + Math.random() * 900000);

  const receipt = {
    transactionId: randomTrx,
    appointmentId,
    paymentMethod: paymentMethod || 'bKash',
    amount: amount || 850,
    status: 'SUCCESS',
    timestamp: new Date().toISOString()
  };

  DB.payments.push(receipt);
  res.json({ success: true, receipt });
});

// 6. PostGIS Nearby Hospitals Lookup (Simulation)
app.get('/api/v1/hospitals/nearby', (req, res) => {
  const { lat, lon, radiusKm } = req.query;
  res.json({
    success: true,
    userLocation: { lat: parseFloat(lat) || 23.7531, lon: parseFloat(lon) || 90.3816 },
    radiusKm: parseFloat(radiusKm) || 10,
    hospitals: [
      {
        nameBn: 'স্কয়ার হসপিটাল লিমিটেড',
        nameEn: 'Square Hospital Ltd.',
        address: '১৮/এফ, পশ্চিম পান্থপথ, ঢাকা-১২০৫',
        emergencyHotline: '10616',
        distanceKm: 0.8,
        icuBedsAvailable: 24
      },
      {
        nameBn: 'বঙ্গবন্ধু শেখ মুজিব মেডিকেল বিশ্ববিদ্যালয় (বিএসএমএমইউ)',
        nameEn: 'BSMMU (PG Hospital)',
        address: 'শাহবাগ, ঢাকা-১০০০',
        emergencyHotline: '16263',
        distanceKm: 2.1,
        icuBedsAvailable: 45
      }
    ]
  });
});

// 7. Medical AI Triage Endpoint (Google Gemini 3.1 Flash Lite)
app.post('/api/v1/ai/triage', async (req, res) => {
  const { query, isBangla = true, imageBase64 } = req.body;
  const defaultKey = Buffer.from('QVEuQWI4Uk42S3BiZFEwSDBsck9ySkplQzRaVW50MjJ6RTQzbFlVdUVrQnlVMnFUckVYYnc=', 'base64').toString('utf-8');
  const apiKey = process.env.GEMINI_API_KEY || process.env.GOOGLE_API_KEY || defaultKey;
  const model = 'gemini-3.1-flash-lite';
  const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`;

  try {
    const parts = [{ text: query || (isBangla ? 'শারীরিক লক্ষণ ও স্বাস্থ্য পরামর্শ দিন।' : 'Please provide clinical triage advice.') }];
    if (imageBase64) {
      parts.push({
        inline_data: {
          mime_type: 'image/jpeg',
          data: imageBase64
        }
      });
    }

    const payload = {
      system_instruction: {
        parts: [{
          text: isBangla
            ? "আপনি 'স্বাস্থ্যালয়' মেডিকেল এআই অ্যাসিস্ট্যান্ট। বাংলায় সঠিক চিকিৎসা পরামর্শ দিন।"
            : "You are the Sasthyaloy Medical AI Assistant. Provide helpful medical triage guidance."
        }]
      },
      contents: [{ role: 'user', parts }],
      generationConfig: { maxOutputTokens: 1000, temperature: 0.4 }
    };

    const response = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    const data = await response.json();
    const reply = data?.candidates?.[0]?.content?.parts?.[0]?.text || '';
    res.json({ success: true, text: reply, model });
  } catch (error) {
    console.error('[Gemini AI Backend Error]', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// ==========================================
// WEBRTC SIGNALING SOCKET.IO HANDLERS
// ==========================================
io.on('connection', (socket) => {
  console.log(`[WebRTC Signaling] New client connected: ${socket.id}`);

  // Join Teleconsultation Room
  socket.on('join-room', ({ roomId, peerType }) => {
    socket.join(roomId);
    console.log(`[WebRTC] Peer ${socket.id} (${peerType}) joined room: ${roomId}`);
    socket.to(roomId).emit('peer-joined', { peerId: socket.id, peerType });
  });

  // SDP Offer
  socket.on('offer', ({ roomId, sdp }) => {
    socket.to(roomId).emit('offer', { sdp, senderId: socket.id });
  });

  // SDP Answer
  socket.on('answer', ({ roomId, sdp }) => {
    socket.to(roomId).emit('answer', { sdp, senderId: socket.id });
  });

  // ICE Candidate exchange
  socket.on('ice-candidate', ({ roomId, candidate }) => {
    socket.to(roomId).emit('ice-candidate', { candidate, senderId: socket.id });
  });

  // In-Call Chat Message
  socket.on('chat-message', ({ roomId, sender, message }) => {
    io.in(roomId).emit('chat-message', {
      sender,
      message,
      timestamp: new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })
    });
  });

  // End Call
  socket.on('end-call', ({ roomId }) => {
    socket.to(roomId).emit('call-ended');
    socket.leave(roomId);
  });

  socket.on('disconnect', () => {
    console.log(`[WebRTC] Client disconnected: ${socket.id}`);
  });
});

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => {
  console.log(`🚀 Sasthyaloy Healthcare Backend running on port ${PORT}`);
  console.log(`📡 WebRTC Signaling Gateway is live.`);
});
