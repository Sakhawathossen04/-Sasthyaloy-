// Patients Data Mock
const patients = [
  {
    id: 1,
    serial: '#SL-1001',
    name: 'মো. সাখাওয়াত হোসেন (Md. Sakhawat Hossen)',
    meta: 'সিরিয়াল: #SL-1001 | বয়স: ২৯ | লিঙ্গ: পুরুষ | অ্যালার্জি: Penicillin, Dust | ক্রনিক ডিজিজ: Mild Asthma',
    vitals: { bp: '120/80 mmHg', sugar: '5.8 mmol/L', pulse: '74 bpm', spo2: '99%' },
    isVideo: true
  },
  {
    id: 2,
    serial: '#SL-1002',
    name: 'রোকেয়া বেগম (Rokeya Begum)',
    meta: 'সিরিয়াল: #SL-1002 | বয়স: ৫৪ | লিঙ্গ: মহিলা | অ্যালার্জি: None | ক্রনিক ডিজিজ: Type 2 Diabetes, Hypertension',
    vitals: { bp: '145/95 mmHg', sugar: '8.4 mmol/L', pulse: '82 bpm', spo2: '98%' },
    isVideo: false
  },
  {
    id: 3,
    serial: '#SL-1003',
    name: 'আব্দুল কাদের (Abdul Kader)',
    meta: 'সিরিয়াল: #SL-1003 | বয়স: ৪২ | লিঙ্গ: পুরুষ | অ্যালার্জি: Sulfa drugs | ক্রনিক ডিজিজ: None',
    vitals: { bp: '118/76 mmHg', sugar: '6.1 mmol/L', pulse: '70 bpm', spo2: '99%' },
    isVideo: true
  }
];

let currentPatient = patients[0];
let isCallActive = false;

function selectPatient(id) {
  const patient = patients.find(p => p.id === id);
  if (!patient) return;

  currentPatient = patient;
  document.getElementById('patientHeaderName').innerText = patient.name;
  document.getElementById('patientHeaderMeta').innerText = patient.meta;

  const cards = document.querySelectorAll('.queue-card');
  cards.forEach((c, idx) => {
    if (idx + 1 === id) {
      c.classList.add('active');
    } else {
      c.classList.remove('active');
    }
  });

  const startCallBtn = document.getElementById('startCallBtn');
  if (patient.isVideo) {
    startCallBtn.style.display = 'flex';
  } else {
    startCallBtn.style.display = 'none';
  }
}

function toggleVideoCall() {
  const panel = document.getElementById('videoCallPanel');
  const btn = document.getElementById('startCallBtn');

  if (!isCallActive) {
    panel.style.display = 'block';
    btn.style.display = 'none';
    isCallActive = true;
  } else {
    panel.style.display = 'none';
    btn.style.display = 'flex';
    isCallActive = false;
    alert('ভিডিও কল সেশন সমাপ্ত হয়েছে। কল লগ ডেটাবেসে সংরক্ষিত হলো।');
  }
}

function addMedicineRow() {
  const container = document.getElementById('medicineRows');
  const div = document.createElement('div');
  div.className = 'medicine-row';
  div.innerHTML = `
    <input type="text" placeholder="ওষুধের নাম (e.g. Tab. Ace Plus)" required>
    <select>
      <option value="১+০+১ (সকাল ও রাত)">১+০+১ (সকাল ও রাত)</option>
      <option value="১+১+১ (সকাল, দুপুর ও রাত)">১+১+১ (৩ বার)</option>
      <option value="০+০+১ (রাতে একবার)">০+০+১ (রাতে একবার)</option>
    </select>
    <select>
      <option value="খাবারের পর (After Meal)">খাবারের পর</option>
      <option value="খাবারের আগে (Before Meal)">খাবারের আগে</option>
    </select>
    <input type="text" placeholder="কত দিন" value="৭ দিন" style="width: 90px;">
  `;
  container.appendChild(div);
}

function generatePrescription(e) {
  e.preventDefault();
  const diagnosis = document.getElementById('rxDiagnosis').value;
  const advice = document.getElementById('rxAdvice').value;

  alert(`প্রেসক্রিপশন সফলভাবে সাইন করা হয়েছে এবং ${currentPatient.name}-এর স্বাস্থ্যালয় অ্যাকাউন্টে সিঙ্ক হয়েছে!\n\nডায়াগনোসিস: ${diagnosis}\nউপদেশ: ${advice}`);
}
