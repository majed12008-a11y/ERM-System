import fs from 'fs';
import path from 'path';
import crypto from 'crypto';
import { deflateSync } from 'zlib';
import PDFDocument from 'pdfkit';
import ExcelJS from 'exceljs';
import * as docx from 'docx';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const UPLOADS_ROOT = path.resolve(__dirname, '..', 'uploads');
const FLAT_DIR = path.join(UPLOADS_ROOT, 'documents');
const FONT = 'C:\\Windows\\Fonts\\arial.ttf';
const FONT_BOLD = 'C:\\Windows\\Fonts\\arialbd.ttf';
const FONT_AR = 'C:\\Windows\\Fonts\\arial.ttf';

function repeatStr(s, n) { let r = ''; for (let i = 0; i < n; i++) r += s; return r; }

const CONTENT = {
  protocolAr: (title, n) => {
    let s = `بروتوكول البحث العلمي\nعنوان البحث: ${title}\nرقم البروتوكول: PR-${crypto.randomBytes(4).toString('hex').toUpperCase()}\nتاريخ الاعتماد: ${new Date().toLocaleDateString('ar-SA')}\n---`;
    for (let i = 0; i < (n || 5); i++) s += `\n\n## القسم ${i + 1}: ${['مقدمة', 'أهداف البحث', 'منهجية البحث', 'جمع البيانات', 'تحليل البيانات'][i % 5]}\n${repeatStr('يهدف هذا البحث إلى دراسة وتحليل البيانات المتعلقة بالمجال الصحي في الجمهورية اليمنية. ', 15 + i * 3)}\n\nجدول ${i + 1}: إحصائيات الدراسة\n| المتغير | القيمة | النسبة المئوية |\n|---------|-------|---------------|\n| إجمالي المشاركين | ${500 + i * 50} | 100% |\n| ذكور | ${250 + i * 25} | ${(50 + i * 0.5).toFixed(1)}% |\n| إناث | ${250 + i * 25} | ${(50 - i * 0.5).toFixed(1)}% |\n${repeatStr('تتضمن منهجية البحث استخدام أدوات جمع البيانات المعتمدة. ', 15 + i * 2)}\n---`;
    s += `\n\nالموافقة الأخلاقية: تمت مراجعة هذا البروتوكول من قبل اللجنة الأخلاقية.\nتوقيع الباحث الرئيسي: _____________\nالتاريخ: ${new Date().toLocaleDateString('ar-SA')}`;
    return s;
  },
  protocolEn: (title, n) => {
    let s = `RESEARCH PROTOCOL\nStudy Title: ${title}\nProtocol Number: PR-${crypto.randomBytes(4).toString('hex').toUpperCase()}\nDate: ${new Date().toLocaleDateString('en-US')}\n---`;
    for (let i = 0; i < (n || 5); i++) s += `\n\n## Section ${i + 1}: ${['Introduction', 'Objectives', 'Methodology', 'Data Collection', 'Data Analysis'][i % 5]}\n${repeatStr('This research aims to study and analyze health-related data in Yemen. ', 15 + i * 3)}\n\nTable ${i + 1}: Study Statistics\n| Variable | Value | Percentage |\n|---------|-------|-----------|\n| Total Participants | ${500 + i * 50} | 100% |\n| Male | ${250 + i * 25} | ${(50 + i * 0.5).toFixed(1)}% |\n| Female | ${250 + i * 25} | ${(50 - i * 0.5).toFixed(1)}% |\n${repeatStr('The methodology includes validated data collection tools. ', 15 + i * 2)}\n---`;
    s += `\n\nEthical Approval: This protocol has been reviewed and approved.\nPrincipal Investigator Signature: _____________`;
    return s;
  },
  icfAr: (title) => `نموذج الموافقة المستنيرة\nعنوان الدراسة: ${title}\nرقم الموافقة: ICF-${crypto.randomBytes(4).toString('hex').toUpperCase()}\n---\n## معلومات المشارك\nأنت مدعو للمشاركة في دراسة بحثية.\n\n## الغرض من الدراسة\n${repeatStr('تهدف هذه الدراسة إلى جمع معلومات حول الحالة الصحية للمشاركين. ', 10)}\n\n## الإجراءات\n- الإجابة على استبيان مدته 30 دقيقة\n- قياس المؤشرات الحيوية (الوزن، الطول، ضغط الدم)\n- سحب عينة دم (5 مل)\n\n## السرية\n${repeatStr('سيتم التعامل مع جميع المعلومات بسرية تامة. ', 8)}\n\n## بيان الموافقة\nأؤكد أنني قرأت وفهمت المعلومات المذكورة أعلاه.\n\n| البيان | التوقيع | التاريخ |\n|-------|---------|--------|\n| اسم المشارك: _____________ | _____________ | _____________ |\n| اسم الباحث: _____________ | _____________ | _____________ |`,
  icfEn: (title) => `INFORMED CONSENT FORM\nStudy Title: ${title}\nConsent Number: ICF-${crypto.randomBytes(4).toString('hex').toUpperCase()}\n---\n## Participant Information\nYou are invited to take part in a research study.\n\n## Purpose\n${repeatStr('This study aims to collect health information. ', 10)}\n\n## Procedures\n- Complete a 30-minute questionnaire\n- Vital signs measurement\n- Blood sample collection (5 mL)\n\n## Confidentiality\n${repeatStr('All information you provide will be treated as strictly confidential. ', 8)}\n\n## Consent Statement\nI confirm that I have read and understood the above information.\n\n| Statement | Signature | Date |\n|----------|-----------|------|\n| Participant: _____________ | _____________ | _____________ |\n| Researcher: _____________ | _____________ | _____________ |`,
  cv: (name) => `CURRICULUM VITAE\n---\nPersonal Information:\nName: ${name || 'Dr. Researcher'}\nTitle: Principal Investigator\nSpecialty: Public Health / Epidemiology\nNationality: Yemeni\n---\nEducation:\n- PhD in Public Health, University of Sana'a, 2018\n- MSc in Epidemiology, University of Aden, 2012\n- MD, University of Sana'a, 2008\n---\nProfessional Experience:\n| Period | Position | Institution |\n|--------|---------|------------|\n| 2019-Present | Associate Professor | University of Sana'a |\n| 2015-2019 | Senior Researcher | National Public Health Lab |\n| 2012-2015 | Medical Officer | Ministry of Health |\n---\nPublications:\n1. Al-Yemeni A, et al. (2023). Prevalence of NCDs in Yemen.\n2. Al-Yemeni A, et al. (2022). Risk factors for hypertension.\n---\nSkills:\n- Statistical analysis (SPSS, Stata, R)\n- Survey design and implementation\n- Ethical review and IRB procedures\n---\nSignature: _____________\nDate: ${new Date().toLocaleDateString('en-US')}`,
  pisAr: (title) => `نشرة معلومات المشارك\nعنوان الدراسة: ${title}\n---\n## ما هي هذه الدراسة؟\n${repeatStr('هذه دراسة بحثية تهدف إلى جمع معلومات صحية مهمة. ', 10)}\n\n## هل يجب أن أشارك؟\nالمشاركة تطوعية تماماً.\n\n## ماذا سيحدث إذا شاركت؟\n- المقابلة لجمع المعلومات الديموغرافية\n- قياس المؤشرات الحيوية\n- سحب عينة دم صغيرة\n\n## من يمكنني الاتصال به؟\nللاستفسارات: الباحث الرئيسي - 777000000`,
  pisEn: (title) => `PARTICIPANT INFORMATION SHEET\nStudy Title: ${title}\n---\n## What is this study?\n${repeatStr('This research study aims to collect important health information. ', 10)}\n\n## Do I have to take part?\nParticipation is entirely voluntary.\n\n## What will happen?\n- Demographic information collection\n- Vital signs measurement\n- Blood sample collection\n\n## Contact\nInquiries: Principal Investigator - +967-777-000-000`,
  ethicsAr: (title) => `قرار اللجنة الأخلاقية\nرقم القرار: ED-${crypto.randomBytes(4).toString('hex').toUpperCase()}\nتاريخ الاجتماع: ${new Date().toLocaleDateString('ar-SA')}\nعنوان الدراسة: ${title}\n---\n## القرار\nالموافقة على إجراء البحث\n\n## التوصيات\n1. الالتزام ببروتوكول البحث المعتمد\n2. الحصول على الموافقة المستنيرة\n3. تقديم تقارير مرحلية\n4. الحفاظ على سرية البيانات\n\n---\nرئيس اللجنة: د. أحمد محمد\nالتوقيع: _____________`,
  ethicsEn: (title) => `ETHICS COMMITTEE DECISION\nDecision No: ED-${crypto.randomBytes(4).toString('hex').toUpperCase()}\nMeeting Date: ${new Date().toLocaleDateString('en-US')}\nStudy Title: ${title}\n---\n## Decision\nApproved\n\n## Recommendations\n1. Follow approved research protocol\n2. Obtain informed consent\n3. Submit progress reports\n4. Maintain confidentiality\n\n---\nChairperson: Dr. Ahmed Mohammed\nSignature: _____________`,
  reportAr: (title) => `التقرير النهائي للبحث\nعنوان البحث: ${title}\nتاريخ التقرير: ${new Date().toLocaleDateString('ar-SA')}\n---\n## ملخص تنفيذي\n${repeatStr('تم إنجاز هذا البحث وفقاً للبروتوكول المعتمد. ', 15)}\n\n## النتائج\n| المتغير | القيمة |\n|---------|-------|\n| إجمالي المشاركين | ${500 + Math.floor(Math.random() * 500)} |\n| ذكور | ${200 + Math.floor(Math.random() * 200)} |\n| إناث | ${200 + Math.floor(Math.random() * 200)} |\n\n---\nالباحث الرئيسي: _____________`,
  reportEn: (title) => `FINAL RESEARCH REPORT\nResearch Title: ${title}\nReport Date: ${new Date().toLocaleDateString('en-US')}\n---\n## Executive Summary\n${repeatStr('This research was completed according to the approved protocol. ', 15)}\n\n## Results\n| Variable | Value |\n|---------|-------|\n| Total Participants | ${500 + Math.floor(Math.random() * 500)} |\n| Male | ${200 + Math.floor(Math.random() * 200)} |\n| Female | ${200 + Math.floor(Math.random() * 200)} |\n\n---\nPrincipal Investigator: _____________`,
  minutesAr: () => `محضر اجتماع اللجنة الأخلاقية\nالتاريخ: ${new Date().toLocaleDateString('ar-SA')}\nالرقم: MM-${crypto.randomBytes(4).toString('hex').toUpperCase()}\n---\n## الحضور\n| الاسم | الصفة |\n|------|-------|\n| د. أحمد محمد | رئيس اللجنة |\n| د. سارة عبدالله | نائب الرئيس |\n| د. خالد علي | عضو |\n\n## جدول الأعمال\n1. مراجعة طلبات البحوث الجديدة\n2. مناقشة التقارير المرحلية\n\n## القرارات\n- الموافقة على ${Math.ceil(Math.random() * 5)} طلب\n- طلب تعديلات على ${Math.ceil(Math.random() * 3)} طلب\n\n---\nرئيس اللجنة: د. أحمد محمد`,
  minutesEn: () => `ETHICS COMMITTEE MEETING MINUTES\nDate: ${new Date().toLocaleDateString('en-US')}\nMinutes No: MM-${crypto.randomBytes(4).toString('hex').toUpperCase()}\n---\n## Attendance\n| Name | Role |\n|------|------|\n| Dr. Ahmed Mohammed | Chairperson |\n| Dr. Sara Abdullah | Vice Chair |\n| Dr. Khaled Ali | Member |\n\n## Agenda\n1. Review of new applications\n2. Progress reports discussion\n\n## Decisions\n- Approved ${Math.ceil(Math.random() * 5)} applications\n- Revisions requested for ${Math.ceil(Math.random() * 3)} applications\n\n---\nChairperson: Dr. Ahmed Mohammed`,
  irbAr: (title) => `خطاب موافقة المؤسسة\nرقم الخطاب: IRB-${crypto.randomBytes(4).toString('hex').toUpperCase()}\nالتاريخ: ${new Date().toLocaleDateString('ar-SA')}\n---\nالموضوع: الموافقة على إجراء البحث\n\n${repeatStr('نفيدكم بموافقة مؤسستنا على إجراء البحث المعنون. ', 10)}\n\nعنوان البحث: ${title}\n\n---\nمدير المؤسسة: _____________\n[ختم المؤسسة]`,
  irbEn: (title) => `INSTITUTION APPROVAL LETTER\nLetter No: IRB-${crypto.randomBytes(4).toString('hex').toUpperCase()}\nDate: ${new Date().toLocaleDateString('en-US')}\n---\nSubject: Approval to Conduct Research\n\n${repeatStr('We confirm our institutions approval for the research. ', 10)}\n\nStudy Title: ${title}\n\n---\nInstitution Director: _____________\n[INSTITUTION STAMP]`,
  dataAr: () => `أداة جمع البيانات\n---\nرقم المشارك: _______________   التاريخ: _______________\n\n## المعلومات الديموغرافية\n1. العمر (بالسنوات): _______\n2. الجنس: □ ذكر □ أنثى\n3. المؤهل التعليمي: □ ابتدائي □ ثانوي □ جامعي □ دراسات عليا\n\n## المعلومات الصحية\n9. هل تعاني من أي أمراض مزمنة؟ □ نعم □ لا\n10. هل تتناول أي أدوية بانتظام؟ □ نعم □ لا\n\n## القياسات الحيوية\n| القياس | القيمة |\n|--------|-------|\n| الوزن (كجم) | _______ |\n| الطول (سم) | _______ |\n| ضغط الدم | _______ |\n\n---\nتوقيع الباحث: _______________`,
  dataEn: () => `DATA COLLECTION TOOL\n---\nParticipant ID: _______________   Date: _______________\n\n## Demographic Information\n1. Age (years): _______\n2. Gender: □ Male □ Female\n3. Education: □ Primary □ Secondary □ University □ Postgraduate\n\n## Health Information\n9. Any chronic diseases? □ Yes □ No\n10. Regular medication? □ Yes □ No\n\n## Vital Signs\n| Measurement | Value |\n|------------|-------|\n| Weight (kg) | _______ |\n| Height (cm) | _______ |\n| Blood Pressure | _______ |\n\n---\nResearcher Signature: _______________`,
  proposalAr: (title) => `مقترح الدراسة\nعنوان الدراسة: ${title}\n---\n## الأهداف\n1. دراسة انتشار الحالة في المجتمع اليمني\n2. تحديد عوامل الخطر المرتبطة\n3. تقديم توصيات للتدخلات المناسبة\n\n## المنهجية المقترحة\n${repeatStr('دراسة وصفية مقطعية متعددة المراكز. ', 15)}\n\n## الميزانية المقترحة\n| البند | التكلفة (ريال يمني) |\n|------|-------------------|\n| الرواتب | 2,500,000 |\n| المعدات | 1,500,000 |\n| الإجمالي | 11,500,000 |\n\n---\nمقدم الطلب: _____________`,
  proposalEn: (title) => `STUDY PROPOSAL\nStudy Title: ${title}\n---\n## Objectives\n1. Determine condition prevalence in Yemen\n2. Identify associated risk factors\n3. Recommend interventions\n\n## Proposed Methodology\n${repeatStr('Multi-center descriptive cross-sectional study. ', 15)}\n\n## Proposed Budget\n| Item | Cost (YER) |\n|------|-----------|\n| Personnel | 2,500,000 |\n| Equipment | 1,500,000 |\n| Total | 11,500,000 |\n\n---\nApplicant: _____________`,
  sop: () => `STANDARD OPERATING PROCEDURE\nSOP Number: SOP-${crypto.randomBytes(4).toString('hex').toUpperCase()}\n---\nTitle: Biological Sample Collection and Handling\n\n## 1. Purpose\nTo ensure standardized blood sample collection.\n\n## 2. Scope\nAll research staff involved in sample collection.\n\n## 3. Procedure\n| Step | Action | Responsible |\n|------|--------|------------|\n| 4.1 | Verify participant identity | Phlebotomist |\n| 4.2 | Prepare labeled collection tubes | Phlebotomist |\n| 4.3 | Perform venipuncture | Phlebotomist |\n| 4.4 | Collect 5-10 mL blood | Phlebotomist |\n\n## 4. Safety Precautions\n- Wear PPE (gloves, lab coat, mask)\n- Dispose of sharps properly\n- Follow universal precautions\n\n---\nPrepared by: _____________`,
  publication: (title) => `PUBLICATION\nTitle: ${title} - Results Analysis\nJournal: Yemen Journal of Medical Sciences\nYear: ${2024 + Math.floor(Math.random() * 3)}\n---\n## ABSTRACT\nBackground: Limited data exists on this topic in Yemen.\nMethods: A cross-sectional study was conducted.\nResults: The study revealed important findings (p < 0.05).\nConclusion: These findings have implications for health policy.\n\n## INTRODUCTION\n${repeatStr('Health research in conflict-affected settings presents unique challenges. ', 15)}\n\n## METHODS\n${repeatStr('A cross-sectional study design was employed. ', 15)}\n\n## RESULTS\n${repeatStr('The study population characteristics are summarized below. ', 15)}\n\n## REFERENCES\n1. WHO. Health Situation Report, Yemen. 2024.\n2. UNICEF. Yemen Health Survey. 2023.`,
  amendment: (appNum, title) => `AMENDMENT PACKAGE\nApplication: ${appNum}\nStudy: ${title}\n---\n## Amendment Description\n${repeatStr('This package contains the amended protocol. ', 10)}\n\n## Changes Made\n| # | Section | Original | Amended |\n|---|---------|---------|---------|\n| 1 | Sample Size | 300 | 500 |\n| 2 | Timeline | 8 months | 12 months |\n| 3 | Budget | 8,000,000 | 11,500,000 |\n\n---\nPI: _____________`,
  evidence: (appNum, title) => `EVIDENCE DOCUMENT\nApplication: ${appNum}\nTitle: ${title}\n---\n${repeatStr('Supporting evidence for condition resolution. ', 10)}\n\n## Attachments\n1. Corrective action documentation\n2. Institutional verification\n3. Laboratory results\n\n---\nAuthorized Officer: _____________`,
  certificateAr: (serial, title, holder, date) => `شهادة اعتماد\nالجمهورية اليمنية - وزارة الصحة والبيئة\nاللجنة الأخلاقية للبحوث الطبية\n---\nرقم الشهادة: ${serial}\nتاريخ الإصدار: ${date}\n---\nتشهد اللجنة الأخلاقية بأن\n${holder}\n\nقد استوفى جميع المتطلبات الأخلاقية والعلمية للدراسة:\n${title}\n\n---\nرئيس اللجنة: د. أحمد محمد\n[ختم اللجنة الأخلاقية]`,
  certificateEn: (serial, title, holder, date) => `APPROVAL CERTIFICATE\nRepublic of Yemen - Ministry of Health\nEthics Review Committee\n---\nCertificate No: ${serial}\nIssue Date: ${date}\n---\nThis is to certify that\n${holder}\n\nhas fulfilled all ethical and scientific requirements for:\n${title}\n\n---\nChairperson: Dr. Ahmed Mohammed\n[ETHICS COMMITTEE STAMP]`,
};

// ===================== GENERATORS =====================

function makePdfkitDoc(text, opts = {}) {
  return new Promise((resolve, reject) => {
    const chunks = [];
    const doc = new PDFDocument({
      size: 'A4',
      margins: { top: 50, bottom: 50, left: 50, right: 50 },
      bufferPages: true
    });
    doc.on('data', c => chunks.push(c));
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    doc.on('error', reject);

    if (fs.existsSync(FONT)) doc.registerFont('Arial', FONT);
    if (fs.existsSync(FONT_BOLD)) doc.registerFont('Arial-Bold', FONT_BOLD);

    doc.font('Arial').fontSize(11);
    const lines = text.split('\n');
    for (const line of lines) {
      if (line.startsWith('# ')) {
        doc.fontSize(16).font('Arial-Bold');
        doc.text(line.substring(2), { align: opts.isArabic ? 'right' : 'left' });
        doc.moveDown(0.5);
        doc.fontSize(11).font('Arial');
      } else if (line.startsWith('## ')) {
        doc.fontSize(13).font('Arial-Bold');
        doc.text(line.substring(3), { align: opts.isArabic ? 'right' : 'left' });
        doc.moveDown(0.3);
        doc.fontSize(11).font('Arial');
      } else if (line.startsWith('---')) {
        doc.moveDown(0.5);
      } else if (line.startsWith('|') && line.endsWith('|')) {
        const cells = line.split('|').filter(c => c.trim()).map(c => c.trim());
        const isHeader = line.includes('---');
        if (isHeader) continue;
        try {
          doc.fontSize(9);
          doc.text(cells.join('   |   '), { indent: 20, align: opts.isArabic ? 'right' : 'left' });
          doc.fontSize(11);
        } catch(e) { doc.text(line); }
      } else if (line.trim()) {
        doc.font('Arial').fontSize(11).text(line, { align: opts.isArabic ? 'right' : 'left' });
      } else {
        doc.moveDown(0.5);
      }
    }
    doc.end();
  });
}

async function makeXLSX(rows, sheetName = 'Sheet1') {
  const wb = new ExcelJS.Workbook();
  const ws = wb.addWorksheet(sheetName);
  for (const row of rows) ws.addRow(row);
  ws.getRow(1).font = { bold: true };
  ws.columns.forEach(col => { if (col) col.width = 22; });
  const buf = await wb.xlsx.writeBuffer();
  return Buffer.from(buf);
}

function makeBudgetXLSX() {
  const rows = [
    ['Item', 'Category', 'Qty', 'Unit Cost (YER)', 'Total (YER)'],
    ['Principal Investigator', 'Personnel', 1, 800000, 800000],
    ['Co-Investigator', 'Personnel', 2, 500000, 1000000],
    ['Research Assistant', 'Personnel', 2, 350000, 700000],
    ['Centrifuge', 'Equipment', 1, 450000, 450000],
    ['Freezer -80C', 'Equipment', 1, 800000, 800000],
    ['Gloves (box)', 'Supplies', 50, 3000, 150000],
    ['Syringes (box)', 'Supplies', 20, 5000, 100000],
    ['Field transport', 'Travel', 20, 75000, 1500000],
    ['Per diem', 'Travel', 60, 15000, 900000],
    ['Questionnaire printing', 'Data', 1000, 500, 500000],
    ['Admin overhead', 'Overhead', 1, 1870000, 1870000],
  ];
  const total = rows.slice(1).reduce((s, r) => s + r[4], 0);
  rows.push([]);
  rows.push(['', '', '', 'GRAND TOTAL', total]);
  return makeXLSX(rows, 'Budget');
}

function makeFundingXLSX() {
  const rows = [
    ['Funding Source', 'Type', 'Amount (USD)', 'Amount (YER)', 'Status'],
    ['WHO Yemen Office', 'International', 85000, 21250000, 'Active'],
    ['Ministry of Health', 'Government', 50000, 12500000, 'Active'],
    ['University of Sanaa', 'Academic', 25000, 6250000, 'Active'],
  ];
  rows.push([]);
  rows.push(['Total', '', 160000, 40000000, '']);
  return makeXLSX(rows, 'Funding');
}

function makeDataXLSX() {
  const rows = [['Participant ID', 'Age', 'Gender', 'Weight', 'Height', 'BP_Systolic', 'BP_Diastolic', 'Blood Sugar', 'Smoking']];
  for (let i = 1; i <= 25; i++) {
    rows.push([
      `P-${String(i).padStart(4, '0')}`,
      18 + Math.floor(Math.random() * 50),
      Math.random() > 0.5 ? 'Male' : 'Female',
      +(50 + Math.random() * 40).toFixed(1),
      +(150 + Math.random() * 30).toFixed(1),
      100 + Math.floor(Math.random() * 40),
      60 + Math.floor(Math.random() * 30),
      +(80 + Math.random() * 60).toFixed(0),
      Math.random() > 0.7 ? 'Yes' : 'No',
    ]);
  }
  return makeXLSX(rows, 'Data');
}

async function makeDOCX(title, paragraphs) {
  const doc = new docx.Document({
    sections: [{
      properties: {},
      children: [
        new docx.Paragraph({
          children: [new docx.TextRun({ text: title, bold: true, size: 28, font: 'Arial' })],
          spacing: { after: 300 }
        }),
        ...paragraphs.map(p => new docx.Paragraph({
          children: [new docx.TextRun({ text: p, size: 22, font: 'Arial' })],
          spacing: { after: 120 }
        }))
      ]
    }]
  });
  const buf = await docx.Packer.toBuffer(doc);
  return Buffer.from(buf);
}

// ===================== FILE CLASSIFICATION =====================

function classifyFilename(name) {
  const lower = name.toLowerCase();
  if (lower.includes('protocol')) return 'PROTOCOL';
  if (lower.includes('icf') || lower.includes('consent')) return 'ICF';
  if (lower.startsWith('cv_') || lower.includes('curriculum') || lower.includes('السيرة')) return 'CV';
  if (lower.includes('pis') || lower.includes('participant') || lower.includes('مشارك')) return 'PIS';
  if (lower.includes('proposal') || lower.includes('مقترح')) return 'STUDY_PROPOSAL';
  if (lower.includes('irb') || lower.includes('موافقة المؤسسة') || lower.includes('institution')) return 'IRB_APPROVAL';
  if (lower.includes('ethics') || lower.includes('قرار') || lower.includes('decision')) return 'ETHICS_DECISION';
  if (lower.includes('certificate') || lower.includes('شهادة')) return 'APPROVAL_CERTIFICATE';
  if (lower.includes('final') || lower.includes('report') || lower.includes('تقرير')) return 'FINAL_REPORT';
  if (lower.includes('publication') || lower.includes('منشور')) return 'PUBLICATION';
  if (lower.includes('meeting') || lower.includes('minutes') || lower.includes('محضر')) return 'MEETING_MINUTES';
  if (lower.includes('budget') || lower.includes('ميزانية')) return 'BUDGET';
  if (lower.includes('funding') || lower.includes('تمويل')) return 'FUNDING';
  if (lower.includes('data') || lower.includes('collection') || lower.includes('بيانات')) return 'DATA_COLLECTION';
  if (lower.includes('questionnaire') || lower.includes('استبيان')) return 'QUESTIONNAIRE';
  if (lower.includes('crf') || lower.includes('case report')) return 'CRF';
  if (lower.includes('sop') || lower.includes('standard')) return 'SOP';
  if (lower.includes('amendment') || lower.includes('تعديل')) return 'AMENDMENT_PKG';
  if (lower.includes('evidence') || lower.includes('دليل')) return 'EVIDENCE_DOC';
  if (lower.includes('withdrawal') || lower.includes('انسحاب')) return 'OTHER';
  if (lower.includes('rejection') || lower.includes('رفض')) return 'OTHER';
  if (lower.includes('conditional') || lower.includes('مشروطة')) return 'OTHER';
  if (lower.includes('return') || lower.includes('إرجاع')) return 'OTHER';
  return 'OTHER';
}

function extractAppCode(name) {
  const m = name.match(/APP-\d{4}-\d{6}/);
  return m ? m[0] : null;
}

function extractYear(name) {
  const m = name.match(/APP-(\d{4})-/);
  return m ? parseInt(m[1]) : null;
}

// ===================== FIND HIERARCHICAL SOURCE =====================

function findHierarchicalSource(fileName) {
  const appCode = extractAppCode(fileName);
  const year = extractYear(fileName);

  if (!appCode || !year) return null;

  // Strip app code suffix to get base name
  const ext = path.extname(fileName);
  let baseName = fileName.slice(0, -ext.length);
  baseName = baseName.replace(`_${appCode}`, '') + ext;

  const candidateDirs = [
    path.join(UPLOADS_ROOT, 'applications', String(year), appCode),
    path.join(UPLOADS_ROOT, 'certificates', String(year)),
    path.join(UPLOADS_ROOT, 'evidence', String(year), appCode),
    path.join(UPLOADS_ROOT, 'reports', String(year), appCode),
    path.join(UPLOADS_ROOT, 'amendments', String(year), appCode),
    path.join(UPLOADS_ROOT, 'meeting-minutes', String(year), appCode),
    path.join(UPLOADS_ROOT, 'messages', String(year), appCode),
  ];

  for (const dir of candidateDirs) {
    const fp = path.join(dir, fileName);
    if (fs.existsSync(fp)) return fp;
    // Also try with base name (some files might not have app code in name)
    const fp2 = path.join(dir, baseName);
    if (fs.existsSync(fp2)) return fp2;
  }

  return null;
}

// ===================== GENERATE FILE =====================

async function generateFile(fileName, filePath) {
  const ext = path.extname(fileName).toLowerCase();
  const docType = classifyFilename(fileName);
  const appCode = extractAppCode(fileName) || 'UNKNOWN';
  const title = `Research Study ${appCode}`;
  const isArabic = /[\u0600-\u06FF]/.test(fileName);

  let buffer;

  switch (docType) {
    case 'PROTOCOL':
      buffer = await makePdfkitDoc(CONTENT.protocolAr(title, 5) + '\n\n' + CONTENT.protocolEn(title, 5));
      break;
    case 'ICF':
      if (fileName.includes('_ar_') || (isArabic && !fileName.includes('_en_')))
        buffer = await makePdfkitDoc(CONTENT.icfAr(title));
      else if (fileName.includes('_en_'))
        buffer = await makePdfkitDoc(CONTENT.icfEn(title));
      else
        buffer = await makePdfkitDoc(CONTENT.icfAr(title) + '\n\n---\n\n' + CONTENT.icfEn(title));
      break;
    case 'CV':
      buffer = await makePdfkitDoc(CONTENT.cv(title));
      break;
    case 'PIS':
      buffer = await makePdfkitDoc(CONTENT.pisAr(title) + '\n\n---\n\n' + CONTENT.pisEn(title));
      break;
    case 'STUDY_PROPOSAL':
      buffer = await makePdfkitDoc(CONTENT.proposalAr(title) + '\n\n---\n\n' + CONTENT.proposalEn(title));
      break;
    case 'IRB_APPROVAL':
      buffer = await makePdfkitDoc(CONTENT.irbAr(title) + '\n\n---\n\n' + CONTENT.irbEn(title));
      break;
    case 'ETHICS_DECISION':
      buffer = await makePdfkitDoc(CONTENT.ethicsAr(title) + '\n\n---\n\n' + CONTENT.ethicsEn(title));
      break;
    case 'APPROVAL_CERTIFICATE':
      buffer = await makePdfkitDoc(CONTENT.certificateAr('ERC-00000', title, 'Principal Investigator', new Date().toLocaleDateString('ar-SA')) + '\n\n---\n\n' + CONTENT.certificateEn('ERC-00000', title, 'Principal Investigator', new Date().toLocaleDateString('en-US')));
      break;
    case 'FINAL_REPORT':
      buffer = await makePdfkitDoc(CONTENT.reportAr(title) + '\n\n---\n\n' + CONTENT.reportEn(title));
      break;
    case 'PUBLICATION':
      if (ext === '.docx') {
        const text = CONTENT.publication(title);
        buffer = await makeDOCX(`Publication: ${title}`, text.split('\n').filter(l => l.trim()).map(l => l.replace(/^##?\s*/, '').replace(/^---.*/, '')));
      } else {
        buffer = await makePdfkitDoc(CONTENT.publication(title));
      }
      break;
    case 'MEETING_MINUTES':
      buffer = await makePdfkitDoc(CONTENT.minutesAr() + '\n\n---\n\n' + CONTENT.minutesEn());
      break;
    case 'BUDGET':
      buffer = await makeBudgetXLSX();
      break;
    case 'FUNDING':
      buffer = await makeFundingXLSX();
      break;
    case 'DATA_COLLECTION':
    case 'QUESTIONNAIRE':
    case 'CRF':
      if (ext === '.xlsx')
        buffer = await makeDataXLSX();
      else
        buffer = await makePdfkitDoc(CONTENT.dataAr() + '\n\n---\n\n' + CONTENT.dataEn());
      break;
    case 'SOP':
      buffer = await makePdfkitDoc(CONTENT.sop());
      break;
    case 'AMENDMENT_PKG':
      buffer = await makePdfkitDoc(CONTENT.amendment(appCode, title));
      break;
    case 'EVIDENCE_DOC':
      if (ext.match(/\.(jpg|jpeg|png)$/i)) {
        buffer = makePNG(400, 300);
      } else {
        buffer = await makePdfkitDoc(CONTENT.evidence(appCode, title));
      }
      break;
    default:
      if (ext.match(/\.(docx?)$/i)) {
        buffer = await makeDOCX(`Supporting: ${title}`, [`Application: ${appCode}`, `Title: ${title}`, '', 'Additional supporting documentation.']);
      } else if (ext.match(/\.(xlsx?|csv)$/i)) {
        buffer = await makeXLSX([['Document ID', 'Type', 'Title', 'Date'], ['1', docType, title, new Date().toISOString().split('T')[0]]], 'Documents');
      } else {
        buffer = await makePdfkitDoc(`Supporting Document\nApplication: ${appCode}\nTitle: ${title}\n\nAdditional supporting documentation.`);
      }
  }

  // Pad to minimum size
  const MIN_SIZES = {
    PROTOCOL: 50000, ICF: 25000, CV: 20000, PIS: 15000,
    IRB_APPROVAL: 20000, ETHICS_DECISION: 15000, APPROVAL_CERTIFICATE: 25000,
    FINAL_REPORT: 40000, MEETING_MINUTES: 20000, STUDY_PROPOSAL: 25000,
    DATA_COLLECTION: 15000, QUESTIONNAIRE: 12000, CRF: 15000,
    PUBLICATION: 30000, SOP: 15000, FUNDING: 10000, BUDGET: 10000,
    EVIDENCE_DOC: 15000, AMENDMENT_PKG: 25000, OTHER: 10000
  };
  const targetMin = MIN_SIZES[docType] || 10000;
  if (buffer.length < targetMin) {
    const padSize = targetMin - buffer.length + Math.floor(Math.random() * targetMin * 0.2);
    buffer = Buffer.concat([buffer, Buffer.alloc(padSize, ' ')]);
  }

  return buffer;
}

function makePNG(width, height) {
  const header = Buffer.from([0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A]);
  const ihdrData = Buffer.alloc(13);
  ihdrData.writeUInt32BE(width, 0);
  ihdrData.writeUInt32BE(height, 4);
  ihdrData[8] = 8; ihdrData[9] = 2; ihdrData[10] = 0; ihdrData[11] = 0; ihdrData[12] = 0;
  const rawData = [];
  for (let y = 0; y < height; y++) {
    rawData.push(0);
    for (let x = 0; x < width; x++) {
      const r = Math.floor(180 + 75 * Math.sin(x/20 + y/30));
      const g = Math.floor(160 + 95 * Math.cos(x/25 + y/20));
      const b = Math.floor(200 + 55 * Math.sin(x/15 - y/25));
      rawData.push(Math.min(255,Math.max(0,r)),Math.min(255,Math.max(0,g)),Math.min(255,Math.max(0,b)));
    }
  }
  const compressed = deflateSync(Buffer.from(rawData));
  const idat = pngChunk('IDAT', compressed);
  const iend = pngChunk('IEND', Buffer.alloc(0));
  const ihdr = pngChunk('IHDR', ihdrData);
  return Buffer.concat([header, ihdr, idat, iend]);
}

function pngChunk(type, data) {
  const len = Buffer.alloc(4); len.writeUInt32BE(data.length, 0);
  const t = Buffer.from(type, 'ascii');
  const crcData = Buffer.concat([t, data]);
  let crc = 0xFFFFFFFF;
  for (let i = 0; i < crcData.length; i++) { crc ^= crcData[i]; for (let j = 0; j < 8; j++) crc = (crc >>> 1) ^ (crc & 1 ? 0xEDB88320 : 0); }
  const crcB = Buffer.alloc(4); crcB.writeUInt32BE((crc ^ 0xFFFFFFFF) >>> 0, 0);
  return Buffer.concat([len, t, data, crcB]);
}

// ===================== PARSE SEED SQL =====================

function parseSeedFile(filePath) {
  if (!fs.existsSync(filePath)) return [];
  const content = fs.readFileSync(filePath, 'utf8');
  const paths = [];
  // Match storage_path values: 'uploads/documents/filename.ext' or "uploads/documents/filename.ext"
  const regex = /'uploads\/documents\/([^']+)'/g;
  let match;
  while ((match = regex.exec(content)) !== null) {
    paths.push(match[1]);
  }
  return paths;
}

function getSeedPaths() {
  const seedDir = path.resolve(__dirname, '..', 'seed');
  const seedFiles = [
    '54-yemen-documents.sql',
    '09-meetings-etc.sql',
    '20-remaining-core-data.sql',
    '45-certificates.sql',
  ];
  const allPaths = new Set();
  for (const f of seedFiles) {
    const fp = path.join(seedDir, f);
    const paths = parseSeedFile(fp);
    for (const p of paths) allPaths.add(p);
  }
  return [...allPaths].sort();
}

// ===================== MAIN =====================

async function main() {
  console.log('=== Physical Document Repository — Flat Generation ===\n');

  fs.mkdirSync(FLAT_DIR, { recursive: true });

  // Get all storage_path filenames from seed SQL
  const seedFilenames = getSeedPaths();
  console.log(`Expected from seed SQL: ${seedFilenames.length} files\n`);

  let copied = 0, generated = 0, existed = 0, errors = 0;
  const updates = []; // { filename, checksum, file_size }
  let totalSize = 0;

  // Scan existing hierarchical files for quick lookup
  const hierarchicalFiles = new Map();
  function scanDir(dir) {
    if (!fs.existsSync(dir)) return;
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) scanDir(full);
      else if (entry.isFile()) hierarchicalFiles.set(entry.name, full);
    }
  }
  console.log('Scanning existing hierarchical files...');
  scanDir(UPLOADS_ROOT);
  console.log(`Found ${hierarchicalFiles.size} existing files on disk.\n`);

  for (const fileName of seedFilenames) {
    const flatPath = path.join(FLAT_DIR, fileName);

    try {
      // Already exists at flat location?
      if (fs.existsSync(flatPath)) {
        const stat = fs.statSync(flatPath);
        if (stat.size > 100) {
          existed++;
          const sha256 = crypto.createHash('sha256').update(fs.readFileSync(flatPath)).digest('hex');
          updates.push({ filename: fileName, checksum: sha256, file_size: stat.size });
          totalSize += stat.size;
          continue;
        }
      }

      // Try to copy from existing hierarchical source
      const srcPath = hierarchicalFiles.get(fileName);
      if (srcPath && fs.existsSync(srcPath)) {
        fs.copyFileSync(srcPath, flatPath);
        const stat = fs.statSync(flatPath);
        const sha256 = crypto.createHash('sha256').update(fs.readFileSync(flatPath)).digest('hex');
        updates.push({ filename: fileName, checksum: sha256, file_size: stat.size });
        totalSize += stat.size;
        copied++;
        if (copied % 200 === 0) console.log(`  Copied ${copied} files...`);
        continue;
      }

      // Try to find by looking in all subdirectories (the hierarchical file might have same name as flat)
      // The flat filenames include APP code (e.g., protocol_v1_APP-2025-001002.pdf)
      // Hierarchical files are stored in subdirectories but with the same full name
      // We already checked hierarchicalFiles map above, so if not found, need to generate

      // Generate from scratch
      console.log(`  Generating: ${fileName}`);
      const buffer = await generateFile(fileName, flatPath);

      // Ensure directory exists
      fs.mkdirSync(path.dirname(flatPath), { recursive: true });
      fs.writeFileSync(flatPath, buffer);

      const sha256 = crypto.createHash('sha256').update(buffer).digest('hex');
      const fileSize = buffer.length;
      updates.push({ filename: fileName, checksum: sha256, file_size: fileSize });
      totalSize += fileSize;
      generated++;

    } catch (err) {
      errors++;
      console.error(`  ERROR [${fileName}]: ${err.message}`);
    }
  }

  // Also generate flat files for non-application docs (warfarin, etc.)
  // These are in 09-meetings-etc.sql but may not have app codes
  const extraFiles = [
    'protocol_warfarin_v2.pdf',
    'icf_warfarin.pdf',
    'cv_researcher1.pdf',
    'irb_approval_warfarin.pdf',
    'protocol_breast_cancer_v1.pdf',
    'icf_breast_cancer.pdf',
  ];

  for (const fileName of extraFiles) {
    const flatPath = path.join(FLAT_DIR, fileName);
    if (fs.existsSync(flatPath)) {
      const stat = fs.statSync(flatPath);
      if (stat.size > 100) {
        existed++;
        updates.push({ filename: fileName, checksum: crypto.createHash('sha256').update(fs.readFileSync(flatPath)).digest('hex'), file_size: stat.size });
        continue;
      }
    }
    try {
      console.log(`  Generating (extra): ${fileName}`);
      const buffer = await generateFile(fileName, flatPath);
      fs.writeFileSync(flatPath, buffer);
      const sha256 = crypto.createHash('sha256').update(buffer).digest('hex');
      updates.push({ filename: fileName, checksum: sha256, file_size: buffer.length });
      totalSize += buffer.length;
      generated++;
    } catch (err) {
      errors++;
      console.error(`  ERROR [${fileName}]: ${err.message}`);
    }
  }

  // ===================== OUTPUT SQL =====================

  const sqlPath = path.resolve(__dirname, '..', 'seed', '99-fix-checksums.sql');
  let sql = `-- Generated by generate-physical-files.mjs at ${new Date().toISOString()}\n`;
  sql += `-- Updates checksums and file sizes for all documents with real values\n`;
  sql += `BEGIN;\nSELECT set_config('app.user_id', '1', true);\n\n`;

  // Match by file_name (unique per document) instead of storage_path,
  // since storage_path can be flat (seed SQL) or hierarchical (after generate-commit5-files.mjs)
  for (const u of updates) {
    const escapedName = u.filename.replace(/'/g, "''");
    sql += `UPDATE documents.documents SET checksum_sha256 = '${u.checksum}', file_size_bytes = ${u.file_size} WHERE file_name = '${escapedName}';\n`;
  }

  sql += `\nCOMMIT;\n`;
  fs.writeFileSync(sqlPath, sql, 'utf8');

  // ===================== SUMMARY =====================

  console.log('\n=== GENERATION COMPLETE ===\n');
  console.log(`Already existed: ${existed}`);
  console.log(`Copied from hierarchical: ${copied}`);
  console.log(`Generated from scratch: ${generated}`);
  console.log(`Errors: ${errors}`);
  console.log(`Total files processed: ${existed + copied + generated}`);
  console.log(`Total size: ${(totalSize / (1024*1024)).toFixed(2)} MB`);
  console.log(`\nSQL update script written to: ${sqlPath}`);

  // List flat directory
  const flatFiles = fs.readdirSync(FLAT_DIR).filter(f => !f.startsWith('.'));
  console.log(`\nFlat directory (uploads/documents/): ${flatFiles.length} files`);

  // Check for missing
  const processed = new Set(updates.map(u => u.filename));
  const missing = seedFilenames.filter(f => !processed.has(f));
  if (missing.length > 0) {
    console.log(`\nWARNING: ${missing.length} files missing:`);
    for (const m of missing.slice(0, 20)) console.log(`  - ${m}`);
    if (missing.length > 20) console.log(`  ... and ${missing.length - 20} more`);
  }
}

main().catch(err => {
  console.error('FATAL:', err);
  process.exit(1);
});
