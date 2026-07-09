import pg from 'pg';
import fs from 'fs';
import path from 'path';
import crypto from 'crypto';
import puppeteer from 'puppeteer-core';
import ExcelJS from 'exceljs';
import * as docx from 'docx';
import PDFDocument from 'pdfkit';
import { deflateSync } from 'zlib';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const UPLOADS_ROOT = path.resolve(__dirname, '..', 'uploads');
const CHROME_PATH = 'C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe';
const DB_CONFIG = { host: 'localhost', port: 5432, database: 'ethics_db', user: 'postgres' };
const FONT = 'C:\\Windows\\Fonts\\arial.ttf';
const FONT_BOLD = 'C:\\Windows\\Fonts\\arialbd.ttf';
const pool = new pg.Pool(DB_CONFIG);

// ===================== CONTENT GENERATORS =====================

function repeatStr(s, n) { let r = ''; for (let i = 0; i < n; i++) r += s; return r; }

const CONTENT = {
  protocolAr: (title, n) => {
    let s = `بروتوكول البحث العلمي
عنوان البحث: ${title}
رقم البروتوكول: PR-${crypto.randomBytes(4).toString('hex').toUpperCase()}
تاريخ الاعتماد: ${new Date().toLocaleDateString('ar-SA')}
---`;
    for (let i = 0; i < (n || 10); i++) s += `

## القسم ${i + 1}: ${['مقدمة', 'أهداف البحث', 'منهجية البحث', 'جمع البيانات', 'تحليل البيانات', 'النتائج المتوقعة', 'الاعتبارات الأخلاقية', 'الجدول الزمني', 'الميزانية', 'المراجع'][i % 10]}
${repeatStr('يهدف هذا البحث إلى دراسة وتحليل البيانات المتعلقة بالمجال الصحي في الجمهورية اليمنية. تعتبر هذه الدراسة من الدراسات المهمة التي تساهم في تطوير القطاع الصحي. ', 20 + i * 5)}

جدول ${i + 1}: إحصائيات الدراسة
| المتغير | القيمة | النسبة المئوية |
|---------|-------|---------------|
| إجمالي المشاركين | ${500 + i * 50} | 100% |
| ذكور | ${250 + i * 25} | ${(50 + i * 0.5).toFixed(1)}% |
| إناث | ${250 + i * 25} | ${(50 - i * 0.5).toFixed(1)}% |
| فئة عمرية 18-30 | ${100 + i * 20} | ${(20 + i * 0.2).toFixed(1)}% |
| فئة عمرية 31-50 | ${200 + i * 20} | ${(40 + i * 0.3).toFixed(1)}% |
| فئة عمرية 51+ | ${200 + i * 10} | ${(40 - i * 0.5).toFixed(1)}% |

${repeatStr('تتضمن منهجية البحث استخدام أدوات جمع البيانات المعتمدة والمقابلات الشخصية. يتم تحليل البيانات باستخدام البرامج الإحصائية المتخصصة. ', 30 + i * 3)}

---`;
    s += `

الموافقة الأخلاقية: تمت مراجعة هذا البروتوكول من قبل اللجنة الأخلاقية وحصل على الموافقة.
توقيع الباحث الرئيسي: _____________
التاريخ: ${new Date().toLocaleDateString('ar-SA')}`;
    return s;
  },

  protocolEn: (title, n) => {
    let s = `RESEARCH PROTOCOL
Study Title: ${title}
Protocol Number: PR-${crypto.randomBytes(4).toString('hex').toUpperCase()}
Date: ${new Date().toLocaleDateString('en-US')}
---`;
    for (let i = 0; i < (n || 10); i++) s += `

## Section ${i + 1}: ${['Introduction', 'Objectives', 'Methodology', 'Data Collection', 'Data Analysis', 'Expected Results', 'Ethical Considerations', 'Timeline', 'Budget', 'References'][i % 10]}
${repeatStr('This research aims to study and analyze health-related data in the Republic of Yemen. This study is among the important research contributing to the development of the health sector in Yemen. ', 20 + i * 5)}

Table ${i + 1}: Study Statistics
| Variable | Value | Percentage |
|---------|-------|-----------|
| Total Participants | ${500 + i * 50} | 100% |
| Male | ${250 + i * 25} | ${(50 + i * 0.5).toFixed(1)}% |
| Female | ${250 + i * 25} | ${(50 - i * 0.5).toFixed(1)}% |
| Age 18-30 | ${100 + i * 20} | ${(20 + i * 0.2).toFixed(1)}% |
| Age 31-50 | ${200 + i * 20} | ${(40 + i * 0.3).toFixed(1)}% |
| Age 51+ | ${200 + i * 10} | ${(40 - i * 0.5).toFixed(1)}% |

${repeatStr('The methodology includes validated data collection tools and personal interviews. Data is analyzed using specialized statistical software. ', 30 + i * 3)}

---`;
    s += `

Ethical Approval: This protocol has been reviewed and approved by the ethics committee.
Principal Investigator Signature: _____________
Date: ${new Date().toLocaleDateString('en-US')}`;
    return s;
  },

  icfAr: (title) => {
    let s = `نموذج الموافقة المستنيرة
عنوان الدراسة: ${title}
رقم الموافقة: ICF-${crypto.randomBytes(4).toString('hex').toUpperCase()}
---
## معلومات المشارك
أنت مدعو للمشاركة في دراسة بحثية. قبل أن تقرر المشاركة، من المهم أن تفهم لماذا يتم إجراء هذا البحث وما الذي سيتضمنه. يرجى قراءة المعلومات التالية بعناية.

## الغرض من الدراسة
${repeatStr('تهدف هذه الدراسة إلى جمع معلومات حول الحالة الصحية للمشاركين في المجتمع اليمني، بهدف تحسين الخدمات الصحية المقدمة. ', 20)}

## الإجراءات
- سوف يُطلب منك الإجابة على استبيان مدته 30 دقيقة
- سيتم قياس بعض المؤشرات الحيوية (الوزن، الطول، ضغط الدم)
- قد يُطلب منك سحب عينة دم (5 مل)
- متابعة لمدة 6 أشهر بعد المقابلة الأولية
- زيارة المتابعة كل شهرين

## المخاطر
${repeatStr('لا توجد مخاطر متوقعة من المشاركة. قد تشعر ببعض الانزعاج البسيط عند سحب عينة الدم. ', 15)}

## الفوائد
${repeatStr('قد لا تعود عليك فوائد مباشرة من المشاركة، ولكن المعلومات التي يتم جمعها قد تساعد الآخرين في المستقبل. ', 15)}

## السرية
${repeatStr('سيتم التعامل مع جميع المعلومات التي تقدمها بسرية تامة. سيتم تخزين البيانات في قاعدة بيانات آمنة ولا يمكن التعرف على هويتك من خلالها. ', 15)}

## الحق في الانسحاب
مشاركتك تطوعية تماماً. يمكنك الانسحاب في أي وقت دون أي تأثير على رعايتك الطبية.

## بيان الموافقة
أؤكد أنني قرأت وفهمت المعلومات المذكورة أعلاه، وأوافق طواعية على المشاركة.

| البيان | التوقيع | التاريخ |
|-------|---------|--------|
| اسم المشارك: _____________ | _____________ | _____________ |
| اسم الباحث: _____________ | _____________ | _____________ |

نسخة للمشارك - نسخة في ملف البحث`;
    return s;
  },

  icfEn: (title) => {
    let s = `INFORMED CONSENT FORM
Study Title: ${title}
Consent Number: ICF-${crypto.randomBytes(4).toString('hex').toUpperCase()}
---
## Participant Information
You are invited to take part in a research study. Before you decide, it is important for you to understand why the research is being done and what it will involve.

## Purpose
${repeatStr('This study aims to collect information about participants health status in the Yemeni community, with the goal of improving health services. ', 20)}

## Procedures
- Complete a 30-minute questionnaire
- Vital signs measurement (weight, height, blood pressure)
- Blood sample collection (5 mL)
- Follow-up for 6 months
- Bi-monthly follow-up visits

## Risks
${repeatStr('No significant risks are expected from participation. You may experience minor discomfort during blood sample collection. ', 15)}

## Benefits
${repeatStr('There may be no direct benefit to you, but the information collected may help others in the future. ', 15)}

## Confidentiality
${repeatStr('All information you provide will be treated as strictly confidential. Data will be stored in a secure database. ', 15)}

## Right to Withdraw
Your participation is entirely voluntary. You may withdraw at any time.

## Consent Statement
I confirm that I have read and understood the above information.

| Statement | Signature | Date |
|----------|-----------|------|
| Participant Name: _____________ | _____________ | _____________ |
| Researcher Name: _____________ | _____________ | _____________ |

Copy: Participant - Copy: Site File`;
    return s;
  },

  cv: (name) => {
    return `CURRICULUM VITAE
---
Personal Information:
Name: ${name || 'Dr. Researcher'}
Title: Principal Investigator
Specialty: Public Health / Epidemiology
Nationality: Yemeni
Languages: Arabic (native), English (fluent)
---
Education:
- PhD in Public Health, University of Sana'a, 2018
  - Dissertation: Epidemiological study of NCDs in Yemen
  - Supervisor: Prof. Ahmed Al-Ansi
- MSc in Epidemiology, University of Aden, 2012
  - Thesis: Risk factors for hypertension in urban Yemen
- MD, University of Sana'a, 2008
  - Graduated with honors (top 10%)
- Diploma in Research Ethics, WHO-Geneva, 2019
- Certificate in Advanced Biostatistics, Cairo University, 2015
---
Professional Experience:
| Period | Position | Institution |
|--------|---------|------------|
| 2019-Present | Associate Professor | University of Sana'a, Faculty of Medicine |
| 2015-2019 | Senior Researcher | National Public Health Laboratory |
| 2012-2015 | Medical Officer | Ministry of Health, Yemen |
| 2010-2012 | Research Assistant | Yemen Health Research Council |
| 2008-2010 | Intern Physician | Al-Thawra Hospital, Sana'a |
---
Publications:
1. Al-Yemeni A, et al. (2023). Prevalence of NCDs in Yemen. J Public Health. 45(2):112-125.
2. Al-Yemeni A, et al. (2022). Risk factors for hypertension. Yemen Med J. 18(3):45-58.
3. Al-Yemeni A, et al. (2021). Healthcare access in conflict zones. Int J Health. 33(4):201-215.
4. Al-Yemeni A, et al. (2020). Maternal health in rural Yemen. East Med Health J. 26(1):78-90.
5. Al-Yemeni A, et al. (2019). Diabetes prevalence in Sana'a. Yemen Endocrine J. 12(2):34-48.
---
Research Projects:
1. Principal Investigator: "NCD Risk Factors in Yemen" (2022-2024) - Funding: WHO Yemen
2. Co-Investigator: "Maternal Health Outcomes" (2021-2023) - Funding: UNICEF
3. Principal Investigator: "Healthcare Access in Conflict" (2020-2022) - Funding: University of Sana'a
4. Co-Investigator: "Child Nutrition Survey" (2019-2021) - Funding: WFP Yemen
---
Skills:
- Statistical analysis (SPSS, Stata, R)
- Survey design and implementation
- Ethical review and IRB procedures
- Clinical research coordination
- Scientific writing and publication
---
${repeatStr('References available upon request.\n', 5)}
Signature: _____________
Date: ${new Date().toLocaleDateString('en-US')}`;
  },

  pisAr: (title) => {
    return `نشرة معلومات المشارك
عنوان الدراسة: ${title}
---
## ما هي هذه الدراسة؟
${repeatStr('هذه دراسة بحثية تهدف إلى جمع معلومات صحية مهمة عن المجتمع اليمني. ', 20)}

## لماذا تم اختياري؟
${repeatStr('تم اختيارك لأنك تستوفي معايير الاشتراك في هذه الدراسة. ', 20)}

## هل يجب أن أشارك؟
المشاركة تطوعية تماماً. يمكنك الانسحاب في أي وقت دون أي تأثير على رعايتك الطبية.

## ماذا سيحدث إذا شاركت؟
- سيتم مقابلتك لجمع المعلومات الديموغرافية
- سيتم قياس المؤشرات الحيوية
- سيتم سحب عينة دم صغيرة
- سيتم متابعتك لمدة 6 أشهر

## من يمكنني الاتصال به؟
للاستفسارات: الباحث الرئيسي - 777000000
للاستفسارات الأخلاقية: اللجنة الأخلاقية - 777000111`;
  },

  pisEn: (title) => {
    return `PARTICIPANT INFORMATION SHEET
Study Title: ${title}
---
## What is this study?
${repeatStr('This research study aims to collect important health information about the Yemeni community. ', 20)}

## Why have I been chosen?
${repeatStr('You have been chosen because you meet the inclusion criteria. ', 20)}

## Do I have to take part?
Participation is entirely voluntary. You may withdraw at any time.

## What will happen?
- Demographic information collection
- Vital signs measurement
- Blood sample collection
- 6-month follow-up

## Contact
Inquiries: Principal Investigator - +967-777-000-000
Ethical concerns: Ethics Committee - +967-777-000-111`;
  },

  ethicsAr: (title) => {
    const decisions = ['الموافقة على إجراء البحث', 'الموافقة مع اشتراط تعديلات', 'طلب تعديلات جوهرية', 'رفض طلب البحث'];
    const d = decisions[Math.floor(Math.random() * decisions.length)];
    return `قرار اللجنة الأخلاقية
رقم القرار: ED-${crypto.randomBytes(4).toString('hex').toUpperCase()}
تاريخ الاجتماع: ${new Date().toLocaleDateString('ar-SA')}
الجهة المقدمة: باحث رئيسي
عنوان الدراسة: ${title}
---
## قرار اللجنة
${d}

## التوصيات
1. الالتزام ببروتوكول البحث المعتمد
2. الحصول على الموافقة المستنيرة من جميع المشاركين
3. تقديم تقارير مرحلية كل 6 أشهر
4. إبلاغ اللجنة بأي أحداث سلبية خلال 48 ساعة
5. الحفاظ على سرية بيانات المشاركين
6. الالتزام بمعايير السلامة الحيوية

## أسباب القرار
${repeatStr('بعد مراجعة الطلب والمستندات الداعمة، قررت اللجنة اتخاذ القرار المذكور أعلاه. ', 20)}

---
رئيس اللجنة: د. أحمد محمد
التوقيع: _____________
التاريخ: ${new Date().toLocaleDateString('ar-SA')}`;
  },

  ethicsEn: (title) => {
    const decisions = ['Approved', 'Approved with conditions', 'Revision required', 'Rejected'];
    const d = decisions[Math.floor(Math.random() * decisions.length)];
    return `ETHICS COMMITTEE DECISION
Decision No: ED-${crypto.randomBytes(4).toString('hex').toUpperCase()}
Meeting Date: ${new Date().toLocaleDateString('en-US')}
Applicant: Principal Investigator
Study Title: ${title}
---
## Decision
${d}

## Recommendations
1. Follow the approved research protocol
2. Obtain informed consent from all participants
3. Submit progress reports every 6 months
4. Report adverse events within 48 hours
5. Maintain participant confidentiality
6. Follow biosafety standards

## Rationale
${repeatStr('After reviewing the application and supporting documents, the committee has made the above decision. ', 20)}

---
Chairperson: Dr. Ahmed Mohammed
Signature: _____________
Date: ${new Date().toLocaleDateString('en-US')}`;
  },

  reportAr: (title) => {
    return `التقرير النهائي للبحث
عنوان البحث: ${title}
تاريخ التقرير: ${new Date().toLocaleDateString('ar-SA')}
---
## ملخص تنفيذي
${repeatStr('تم إنجاز هذا البحث وفقاً للبروتوكول المعتمد من اللجنة الأخلاقية. ', 30)}

## النتائج
| المتغير | القيمة |
|---------|-------|
| إجمالي المشاركين | ${500 + Math.floor(Math.random() * 500)} |
| ذكور | ${200 + Math.floor(Math.random() * 200)} |
| إناث | ${200 + Math.floor(Math.random() * 200)} |
| حالات إيجابية | ${50 + Math.floor(Math.random() * 200)} |

${repeatStr('توصلت الدراسة إلى نتائج مهمة تساهم في فهم أفضل للحالة الصحية في الجمهورية اليمنية. ', 40)}

## التوصيات
1. نشر النتائج في مجلات علمية محكمة
2. تقديم توصيات لصناع القرار
3. إجراء بحوث تكميلية
4. تطوير برامج تدريبية

---
الباحث الرئيسي: _____________
تاريخ التسليم: ${new Date().toLocaleDateString('ar-YE')}`;
  },

  reportEn: (title) => {
    return `FINAL RESEARCH REPORT
Research Title: ${title}
Report Date: ${new Date().toLocaleDateString('en-US')}
---
## Executive Summary
${repeatStr('This research was completed according to the approved protocol. ', 30)}

## Results
| Variable | Value |
|---------|-------|
| Total Participants | ${500 + Math.floor(Math.random() * 500)} |
| Male | ${200 + Math.floor(Math.random() * 200)} |
| Female | ${200 + Math.floor(Math.random() * 200)} |
| Positive Cases | ${50 + Math.floor(Math.random() * 200)} |

${repeatStr('The study yielded important findings contributing to better understanding of health conditions in Yemen. ', 40)}

## Recommendations
1. Publish in peer-reviewed journals
2. Provide recommendations to policy makers
3. Conduct additional research
4. Develop training programs

---
Principal Investigator: _____________
Date: ${new Date().toLocaleDateString('en-US')}`;
  },

  minutesAr: () => {
    return `محضر اجتماع اللجنة الأخلاقية
التاريخ: ${new Date().toLocaleDateString('ar-SA')}
الرقم: MM-${crypto.randomBytes(4).toString('hex').toUpperCase()}
---
## الحضور
| الاسم | الصفة |
|------|-------|
| د. أحمد محمد | رئيس اللجنة |
| د. سارة عبدالله | نائب الرئيس |
| د. خالد علي | عضو |
| د. مريم حسن | عضو |
| د. عمر صالح | عضو |
| أ. فاطمة أحمد | مقرر |

## جدول الأعمال
1. مراجعة طلبات البحوث الجديدة
2. مناقشة التقارير المرحلية
3. مراجعة طلبات التعديل
4. تقارير الأحداث السلبية
5. أي أعمال أخرى

${repeatStr('تم استعراض الطلبات ومناقشة كل طلب على حدة. ', 20)}

## القرارات
- الموافقة على ${Math.ceil(Math.random() * 5)} طلب
- طلب تعديلات على ${Math.ceil(Math.random() * 3)} طلب
- رفض ${Math.ceil(Math.random() * 2)} طلب

---
رئيس اللجنة: د. أحمد محمد
المقرر: أ. فاطمة أحمد`;
  },

  minutesEn: () => {
    return `ETHICS COMMITTEE MEETING MINUTES
Date: ${new Date().toLocaleDateString('en-US')}
Minutes No: MM-${crypto.randomBytes(4).toString('hex').toUpperCase()}
---
## Attendance
| Name | Role |
|------|------|
| Dr. Ahmed Mohammed | Chairperson |
| Dr. Sara Abdullah | Vice Chair |
| Dr. Khaled Ali | Member |
| Dr. Maryam Hassan | Member |
| Dr. Omar Saleh | Member |
| Ms. Fatima Ahmed | Secretary |

## Agenda
1. Review of new applications
2. Progress reports discussion
3. Amendment requests review
4. Adverse event reports
5. Other business

${repeatStr('Applications were reviewed and discussed individually. ', 20)}

## Decisions
- Approved ${Math.ceil(Math.random() * 5)} applications
- Revisions requested for ${Math.ceil(Math.random() * 3)} applications
- Rejected ${Math.ceil(Math.random() * 2)} applications

---
Chairperson: Dr. Ahmed Mohammed
Secretary: Ms. Fatima Ahmed`;
  },

  irbAr: (title) => {
    return `خطاب موافقة المؤسسة
رقم الخطاب: IRB-${crypto.randomBytes(4).toString('hex').toUpperCase()}
التاريخ: ${new Date().toLocaleDateString('ar-SA')}
---
الموضوع: الموافقة على إجراء البحث
السيد / رئيس اللجنة الأخلاقية
السلام عليكم ورحمة الله وبركاته،

${repeatStr('نفيدكم بموافقة مؤسستنا على إجراء البحث المعنون في مرافقنا الصحية. ', 20)}

عنوان البحث: ${title}

${repeatStr('نؤكد على توفير التسهيلات اللازمة للباحثين لإنجاز هذا البحث وفق المعايير المعتمدة. ', 20)}

---
مدير المؤسسة: _____________
التوقيع: _____________
التاريخ: _____________
[ختم المؤسسة]`;
  },

  irbEn: (title) => {
    return `INSTITUTION APPROVAL LETTER
Letter No: IRB-${crypto.randomBytes(4).toString('hex').toUpperCase()}
Date: ${new Date().toLocaleDateString('en-US')}
---
Subject: Approval to Conduct Research
The Chairperson, Ethics Review Committee

${repeatStr('We hereby confirm our institutions approval for the research titled to be conducted in our facilities. ', 20)}

Study Title: ${title}

${repeatStr('We confirm that all necessary facilities will be provided to the researchers. ', 20)}

---
Institution Director: _____________
Signature: _____________
Date: _____________
[INSTITUTION STAMP]`;
  },

  dataAr: () => {
    return `أداة جمع البيانات
---
رقم المشارك: _______________   التاريخ: _______________

## المعلومات الديموغرافية
1. العمر (بالسنوات): _______
2. الجنس: □ ذكر □ أنثى
3. المؤهل التعليمي: □ ابتدائي □ ثانوي □ جامعي □ دراسات عليا
4. المهنة: _______
5. محل الإقامة: □ مدينة □ ريف
6. الحالة الاجتماعية: □ أعزب □ متزوج □ مطلق □ أرمل
7. عدد أفراد الأسرة: _______
8. الدخل الشهري: _______

## المعلومات الصحية
9. هل تعاني من أي أمراض مزمنة؟ □ نعم □ لا
10. إذا كانت الإجابة بنعم، اذكرها: _______
11. هل تتناول أي أدوية بانتظام؟ □ نعم □ لا
12. هل لديك تاريخ عائلي للمرض؟ □ نعم □ لا
13. هل قمت بزيارة طبيب خلال الشهر الماضي؟ □ نعم □ لا
14. هل تعاني من أي أعراض حالياً؟ □ نعم □ لا

## القياسات الحيوية
| القياس | القيمة | ملاحظات |
|--------|-------|---------|
| الوزن (كجم) | _______ | |
| الطول (سم) | _______ | |
| ضغط الدم الانقباضي | _______ | |
| ضغط الدم الانبساطي | _______ | |
| معدل النبض | _______ | |
| درجة الحرارة | _______ | |
| نسبة السكر في الدم | _______ | |

## نمط الحياة
15. هل تدخن؟ □ نعم □ لا □ سابقاً
16. هل تمارس الرياضة؟ □ نعم □ لا
17. إذا كانت الإجابة بنعم، كم مرة في الأسبوع؟ _______
18. هل تتبع نظاماً غذائياً خاصاً؟ □ نعم □ لا

---
توقيع الباحث: _______________
التاريخ: _______________`;
  },

  dataEn: () => {
    return `DATA COLLECTION TOOL
---
Participant ID: _______________   Date: _______________

## Demographic Information
1. Age (years): _______
2. Gender: □ Male □ Female
3. Education: □ Primary □ Secondary □ University □ Postgraduate
4. Occupation: _______
5. Residence: □ Urban □ Rural
6. Marital Status: □ Single □ Married □ Divorced □ Widowed
7. Family Size: _______
8. Monthly Income: _______

## Health Information
9. Any chronic diseases? □ Yes □ No
10. If yes, specify: _______
11. Regular medication? □ Yes □ No
12. Family history of disease? □ Yes □ No
13. Visited doctor in past month? □ Yes □ No
14. Current symptoms? □ Yes □ No

## Vital Signs
| Measurement | Value | Notes |
|------------|-------|-------|
| Weight (kg) | _______ | |
| Height (cm) | _______ | |
| Systolic BP | _______ | |
| Diastolic BP | _______ | |
| Pulse Rate | _______ | |
| Temperature | _______ | |
| Blood Sugar | _______ | |

## Lifestyle
15. Do you smoke? □ Yes □ No □ Former
16. Do you exercise? □ Yes □ No
17. If yes, times per week? _______
18. Special diet? □ Yes □ No

---
Researcher Signature: _______________
Date: _______________`;
  },

  sop: () => {
    return `STANDARD OPERATING PROCEDURE
SOP Number: SOP-${crypto.randomBytes(4).toString('hex').toUpperCase()}
Effective Date: ${new Date().toLocaleDateString('en-US')}
---
Title: Biological Sample Collection and Handling

## 1. Purpose
To ensure standardized blood sample collection, handling, and transportation.

## 2. Scope
All research staff involved in biological sample collection.

## 3. Responsibilities
- PI: Overall oversight
- Coordinator: Training and supervision
- Phlebotomist: Sample collection
- Lab Technician: Sample processing

## 4. Procedure
| Step | Action | Responsible |
|------|--------|------------|
| 4.1 | Verify participant identity | Phlebotomist |
| 4.2 | Prepare labeled collection tubes | Phlebotomist |
| 4.3 | Perform venipuncture (sterile technique) | Phlebotomist |
| 4.4 | Collect 5-10 mL blood | Phlebotomist |
| 4.5 | Invert tubes 8-10 times | Phlebotomist |
| 4.6 | Centrifuge at 3000 rpm for 10 min | Lab Tech |
| 4.7 | Aliquot into cryovials | Lab Tech |
| 4.8 | Store at -80°C within 2 hours | Lab Tech |
| 4.9 | Complete laboratory logs | Lab Tech |
| 4.10 | Transport on dry ice if needed | Coordinator |

## 5. Materials Required
- Vacutainer tubes (EDTA, plain, serum separator)
- Needles (21G, 22G)
- Tourniquet
- Alcohol swabs
- Gauze and bandages
- Sharps disposal container
- Labels and markers
- Cooler with ice packs
- Centrifuge
- Cryovials (1.5 mL, 2 mL)
- Permanent marker
- Laboratory request forms

## 6. Safety Precautions
- Wear PPE (gloves, lab coat, mask, eye protection)
- Dispose of sharps in puncture-proof containers
- Follow universal precautions
- Decontaminate surfaces before/after
- Report needle-stick injuries immediately
- Hand washing before and after procedure
- No eating or drinking in lab area

## 7. Quality Control
- Verify patient ID using two identifiers
- Check tube expiration dates
- Monitor centrifuge temperature
- Document any deviations
- Maintain chain of custody

## 8. Troubleshooting
| Problem | Possible Cause | Solution |
|---------|---------------|----------|
| Difficult venipuncture | Dehydrated veins | Warm compress, reposition |
| Hemolyzed sample | Needle too small | Use 21G needle |
| Clotted sample | Inadequate mixing | Invert 8-10 times |
| Insufficient volume | Poor blood flow | Reposition needle |

## 9. References
- WHO Guidelines for Blood Collection (2023)
- CDC Biosafety Guidelines (2022)
- Institutional Safety Manual (2024)

---
Prepared by: _____________
Approved by: _____________
Date: ${new Date().toLocaleDateString('en-US')}`;
  },

  proposalAr: (title) => {
    return `مقترح الدراسة
عنوان الدراسة: ${title}
---
## الأهداف
1. الهدف الرئيسي: دراسة انتشار الحالة في المجتمع اليمني
2. تحديد عوامل الخطر المرتبطة بالحالة
3. تقييم مدى توفر الخدمات الصحية
4. تقديم توصيات للتدخلات المناسبة

## المنهجية المقترحة
${repeatStr('دراسة وصفية مقطعية متعددة المراكز في ثلاث محافظات يمنية. ', 30)}

## الميزانية المقترحة
| البند | التكلفة (ريال يمني) |
|------|-------------------|
| الرواتب | 2,500,000 |
| المعدات | 1,500,000 |
| اللوازم | 2,500,000 |
| السفر | 1,500,000 |
| التحاليل | 3,000,000 |
| النشر | 500,000 |
| الإجمالي | 11,500,000 |

---
مقدم الطلب: _____________
التاريخ: ${new Date().toLocaleDateString('ar-SA')}`;
  },

  proposalEn: (title) => {
    return `STUDY PROPOSAL
Study Title: ${title}
---
## Objectives
1. Primary: Determine condition prevalence in Yemen
2. Identify associated risk factors
3. Assess health service availability
4. Recommend appropriate interventions

## Proposed Methodology
${repeatStr('Multi-center descriptive cross-sectional study in three Yemeni governorates. ', 30)}

## Proposed Budget
| Item | Cost (YER) |
|------|-----------|
| Personnel | 2,500,000 |
| Equipment | 1,500,000 |
| Supplies | 2,500,000 |
| Travel | 1,500,000 |
| Lab Tests | 3,000,000 |
| Publication | 500,000 |
| Total | 11,500,000 |

---
Applicant: _____________
Date: ${new Date().toLocaleDateString('en-US')}`;
  },

  publication: (title) => {
    return `PUBLICATION
Title: ${title} - Results Analysis
Journal: Yemen Journal of Medical Sciences
Year: ${2024 + Math.floor(Math.random() * 3)}
Volume: ${Math.ceil(Math.random() * 20)}
Pages: ${100 + Math.ceil(Math.random() * 50)}-${150 + Math.ceil(Math.random() * 50)}
---
## ABSTRACT
Background: Limited data exists on this topic in Yemen. This study aimed to investigate the prevalence and risk factors.

Methods: A cross-sectional study was conducted among ${200 + Math.floor(Math.random() * 300)} participants.

Results: The study revealed important findings with statistical significance (p < 0.05).

Conclusion: These findings have implications for clinical practice and health policy.

Keywords: Yemen, public health, cross-sectional study

## INTRODUCTION
${repeatStr('Health research in conflict-affected settings presents unique challenges. ', 30)}

## METHODS
${repeatStr('A cross-sectional study design was employed. ', 30)}

## RESULTS
${repeatStr('The study population characteristics are summarized below. ', 30)}

## DISCUSSION
${repeatStr('These findings contribute to the growing body of literature. ', 30)}

## REFERENCES
1. WHO. Health Situation Report, Yemen. 2024.
2. UNICEF. Yemen Health Survey. 2023.
3. The Lancet. Health in Yemen. 2022.`;
  },

  amendment: (appNum, title) => {
    return `AMENDMENT PACKAGE
Application: ${appNum}
---
Study: ${title}

## Amendment Description
${repeatStr('This package contains the amended protocol and supporting documents. ', 20)}

## Changes Made
| # | Section | Original | Amended | Justification |
|---|---------|---------|---------|--------------|
| 1 | Sample Size | 300 | 500 | Statistical power |
| 2 | Timeline | 8 months | 12 months | Recruitment challenges |
| 3 | Consent Form | Standard | Arabic version | Participant comprehension |
| 4 | Data Collection | Paper | Electronic+Paper | Efficiency |
| 5 | Budget | 8,000,000 | 11,500,000 | Extended timeline |

## Justification
${repeatStr('The amendments are necessary to address reviewer comments and improve methodology. ', 20)}

---
PI: _____________
Date: ${new Date().toLocaleDateString('en-US')}`;
  },

  evidence: (appNum, title) => {
    return `EVIDENCE DOCUMENT
Application: ${appNum}
Title: ${title}
---
${repeatStr('Supporting evidence for condition resolution. ', 20)}

## Description
This document provides evidence of compliance with ethics committee conditions.
${repeatStr('The following evidence demonstrates compliance with all requirements. ', 20)}

## Attachments
1. Corrective action documentation
2. Institutional verification
3. Supporting correspondence
4. Photographic evidence
5. Laboratory results

---
Authorized Officer: _____________
Date: ${new Date().toLocaleDateString('en-US')}`;
  }
};

// ===================== PDF GENERATION =====================

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
      } else if (line.startsWith('##')) {
        doc.fontSize(13).font('Arial-Bold');
        doc.text(line.substring(2), { align: opts.isArabic ? 'right' : 'left' });
        doc.moveDown(0.3);
        doc.fontSize(11).font('Arial');
      } else if (line.startsWith('---')) {
        doc.moveDown(0.5);
      } else if (line.includes('|') && !line.trim().startsWith('|')) {
        continue;
      } else if (line.startsWith('|') && line.endsWith('|')) {
        const cells = line.split('|').filter(c => c.trim()).map(c => c.trim());
        const isHeader = line.includes('---') || line.includes('===');
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

    // Add page numbers
    const pages = doc.bufferedPageRange();
    for (let i = pages.start; i < pages.start + pages.count; i++) {
      doc.switchToPage(i);
      doc.font('Arial').fontSize(8).fillColor('#999');
      doc.text(`Page ${i + 1} of ${pages.count}`, 50, doc.page.height - 40, { align: 'center' });
    }

    doc.end();
  });
}

// ===================== CERTIFICATE PDF via Puppeteer =====================

let certBrowser = null;

async function getCertBrowser() {
  if (!certBrowser) {
    certBrowser = await puppeteer.launch({
      executablePath: CHROME_PATH,
      headless: true,
      args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage', '--disable-gpu']
    });
  }
  return certBrowser;
}

function certHtml(serial, title, holder, date, isArabic) {
  const rtl = isArabic ? 'direction:rtl;text-align:right;' : '';
  if (isArabic) {
    return `<!DOCTYPE html><html><head><meta charset="utf-8"><style>
      body{margin:0;padding:0;font-family:Arial,sans-serif;${rtl}}
      .cert{border:6px double #b8860b;margin:20px;padding:40px;text-align:center;min-height:600px;background:#fffaf0}
      h1{font-size:22pt;color:#1a3a5c;border:none;margin-top:10px}
      .sub{font-size:11pt;color:#555;margin-bottom:20px}
      .serial{font-size:16pt;margin:30px 0;color:#333}
      .body-text{font-size:13pt;margin:20px 0;line-height:2}
      .title-line{font-size:14pt;font-weight:bold;font-style:italic;margin:20px 0;color:#1a3a5c}
      .footer{display:flex;justify-content:space-between;margin-top:60px;font-size:11pt}
      .stamp{border:3px double #c00;padding:10px 20px;display:inline-block;color:#c00;font-weight:bold;font-size:13pt}
      hr{border:none;border-top:2px solid #b8860b;margin:20px 0}
      .sig-line{border-top:1px solid #000;width:180px;margin:30px auto 0}
    </style></head><body>
    <div class="cert">
      <h1>اللجنة الأخلاقية للبحوث الطبية</h1>
      <div class="sub">الجمهورية اليمنية - وزارة الصحة والبيئة</div>
      <hr>
      <h1 style="font-size:24pt;">شهادة اعتماد</h1>
      <div class="serial">رقم الشهادة: ${serial}</div>
      <div class="body-text">تاريخ الإصدار: ${date}</div>
      <hr>
      <div class="body-text">تشهد اللجنة الأخلاقية للبحوث الطبية بأن</div>
      <div class="title-line">${holder}</div>
      <div class="body-text">قد استوفى جميع المتطلبات الأخلاقية والعلمية للدراسة بعنوان:</div>
      <div class="title-line">${title}</div>
      <hr>
      <div style="font-size:10pt;color:#666;">تمت المراجعة والموافقة وفقاً للوائح المنظمة للبحوث الطبية في الجمهورية اليمنية</div>
      <div class="footer">
        <div><b>رئيس اللجنة</b><br>د. أحمد محمد<br><div class="sig-line"></div></div>
        <div><div class="stamp">اللجنة الأخلاقية</div></div>
        <div><b>التاريخ</b><br>${date}<br><div class="sig-line"></div></div>
      </div>
    </div></body></html>`;
  }
  return `<!DOCTYPE html><html><head><meta charset="utf-8"><style>
    body{margin:0;padding:0;font-family:Arial,sans-serif}
    .cert{border:6px double #b8860b;margin:20px;padding:40px;text-align:center;min-height:600px;background:#fffaf0}
    h1{font-size:22pt;color:#1a3a5c;border:none;margin-top:10px}
    .sub{font-size:11pt;color:#555;margin-bottom:20px}
    .serial{font-size:16pt;margin:30px 0;color:#333}
    .body-text{font-size:13pt;margin:20px 0;line-height:2}
    .title-line{font-size:14pt;font-weight:bold;font-style:italic;margin:20px 0;color:#1a3a5c}
    .footer{display:flex;justify-content:space-between;margin-top:60px;font-size:11pt}
    .stamp{border:3px double #c00;padding:10px 20px;display:inline-block;color:#c00;font-weight:bold;font-size:13pt}
    hr{border:none;border-top:2px solid #b8860b;margin:20px 0}
    .sig-line{border-top:1px solid #000;width:180px;margin:30px auto 0}
  </style></head><body>
  <div class="cert">
    <h1>ETHICS REVIEW COMMITTEE</h1>
    <div class="sub">Republic of Yemen - Ministry of Public Health and Population</div>
    <hr>
    <h1 style="font-size:24pt;">APPROVAL CERTIFICATE</h1>
    <div class="serial">Certificate No: ${serial}</div>
    <div class="body-text">Issue Date: ${date}</div>
    <hr>
    <div class="body-text">This is to certify that</div>
    <div class="title-line">${holder}</div>
    <div class="body-text">has fulfilled all ethical and scientific requirements for the study titled:</div>
    <div class="title-line">${title}</div>
    <hr>
    <div style="font-size:10pt;color:#666;">Reviewed and approved in accordance with medical research regulations in Yemen</div>
    <div class="footer">
      <div><b>Chairperson</b><br>Dr. Ahmed Mohammed<br><div class="sig-line"></div></div>
      <div><div class="stamp">ETHICS COMMITTEE</div></div>
      <div><b>Date</b><br>${date}<br><div class="sig-line"></div></div>
    </div>
  </div></body></html>`;
}

async function makeCertPDF(html) {
  const browser = await getCertBrowser();
  const page = await browser.newPage();
  try {
    await page.setContent(html, { waitUntil: 'load', timeout: 15000 });
    const pdf = await page.pdf({
      format: 'A4',
      margin: { top: '10mm', bottom: '10mm', left: '10mm', right: '10mm' },
      printBackground: true
    });
    return Buffer.from(pdf);
  } finally {
    await page.close();
  }
}

// ===================== XLSX GENERATION =====================

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
    ['Item', 'Category', 'Qty', 'Unit Cost (YER)', 'Total (YER)', 'Funding Source'],
    ['Principal Investigator', 'Personnel', 1, 800000, 800000, 'Grant'],
    ['Co-Investigator', 'Personnel', 2, 500000, 1000000, 'Grant'],
    ['Research Assistant', 'Personnel', 2, 350000, 700000, 'Grant'],
    ['Field Coordinator', 'Personnel', 1, 400000, 400000, 'Grant'],
    ['Data Entry Clerk', 'Personnel', 2, 250000, 500000, 'Grant'],
    ['Centrifuge', 'Equipment', 1, 450000, 450000, 'Capital'],
    ['Freezer -80C', 'Equipment', 1, 800000, 800000, 'Capital'],
    ['Pipettes (set)', 'Equipment', 3, 50000, 150000, 'Capital'],
    ['Refrigerator', 'Equipment', 1, 350000, 350000, 'Capital'],
    ['Computer', 'Equipment', 3, 400000, 1200000, 'Capital'],
    ['Printer', 'Equipment', 1, 200000, 200000, 'Capital'],
    ['Gloves (box)', 'Supplies', 50, 3000, 150000, 'Consumable'],
    ['Syringes (box)', 'Supplies', 20, 5000, 100000, 'Consumable'],
    ['Vacutainer tubes', 'Supplies', 1000, 800, 800000, 'Consumable'],
    ['Alcohol swabs (box)', 'Supplies', 30, 2000, 60000, 'Consumable'],
    ['Bandages (box)', 'Supplies', 10, 3000, 30000, 'Consumable'],
    ['Lab coats', 'Supplies', 10, 15000, 150000, 'Consumable'],
    ['Field transport', 'Travel', 20, 75000, 1500000, 'Operational'],
    ['Per diem', 'Travel', 60, 15000, 900000, 'Operational'],
    ['Fuel (liters)', 'Travel', 200, 3000, 600000, 'Operational'],
    ['Accommodation', 'Travel', 40, 25000, 1000000, 'Operational'],
    ['Chemistry tests', 'Lab', 500, 8000, 4000000, 'Operational'],
    ['Hematology tests', 'Lab', 500, 5000, 2500000, 'Operational'],
    ['Microbiology tests', 'Lab', 200, 12000, 2400000, 'Operational'],
    ['Serology tests', 'Lab', 300, 7000, 2100000, 'Operational'],
    ['Questionnaire printing', 'Data', 1000, 500, 500000, 'Operational'],
    ['Tablets', 'Data', 5, 200000, 1000000, 'Capital'],
    ['Statistical software', 'Analysis', 1, 500000, 500000, 'Software'],
    ['Publication fee', 'Pub', 1, 500000, 500000, 'Operational'],
    ['Admin overhead', 'Overhead', 1, 1870000, 1870000, 'Institutional'],
  ];
  const total = rows.slice(1).reduce((s, r) => s + r[4], 0);
  rows.push([]);
  rows.push(['', '', '', 'GRAND TOTAL', total, '']);
  return makeXLSX(rows, 'Budget');
}

function makeFundingXLSX() {
  const rows = [
    ['Funding Source', 'Type', 'Amount (USD)', 'Amount (YER)', 'Status', 'Start', 'End', 'Contact'],
    ['WHO Yemen Office', 'International', 85000, 21250000, 'Active', '2025-01-01', '2025-12-31', 'who-yemen@who.int'],
    ['Ministry of Health', 'Government', 50000, 12500000, 'Active', '2025-03-01', '2026-02-28', 'research@moh-ye.org'],
    ['University of Sanaa', 'Academic', 25000, 6250000, 'Active', '2025-02-01', '2026-01-31', 'grants@su.edu.ye'],
    ['UNICEF Yemen', 'International', 40000, 10000000, 'Pending', '2025-06-01', '2026-05-31', 'yemen@unicef.org'],
    ['World Bank Yemen', 'International', 60000, 15000000, 'Pending', '2025-07-01', '2026-06-30', 'yemen@worldbank.org'],
  ];
  rows.push([]);
  rows.push(['Total', '', 260000, 65000000, '', '', '', '']);
  return makeXLSX(rows, 'Funding');
}

function makeDataXLSX() {
  const rows = [['Participant ID', 'Age', 'Gender', 'Weight', 'Height', 'BP_Systolic', 'BP_Diastolic', 'Blood Sugar', 'Smoking', 'Exercise', 'Chronic Disease', 'Notes']];
  for (let i = 1; i <= 50; i++) {
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
      Math.random() > 0.5 ? 'Yes' : 'No',
      Math.random() > 0.6 ? 'Yes' : 'No',
      Math.random() > 0.8 ? 'Follow-up required' : ''
    ]);
  }
  return makeXLSX(rows, 'Data');
}

// ===================== DOCX GENERATION =====================

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

// ===================== IMAGE GENERATION =====================

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

// ===================== MAIN =====================

async function main() {
  console.log('=== Commit 5.5 — Physical Document Repository (pdfkit + Puppeteer for certs) ===\n');

  const client = await pool.connect();
  try {
    const result = await client.query(`
      SELECT d.id, d.document_type_id, d.entity_type, d.entity_id,
             d.document_title, d.file_name, d.mime_type,
             dt.type_code,
             a.application_number,
             COALESCE(p.title_en, p.title_ar) AS project_title,
             EXTRACT(YEAR FROM a.created_at)::int AS app_year
      FROM documents.documents d
      JOIN documents.document_types dt ON dt.id = d.document_type_id
      JOIN core.applications a ON a.id = d.entity_id AND d.entity_type = 'Application'
      LEFT JOIN core.projects p ON p.id = a.project_id
      ORDER BY d.id
    `);
    const docs = result.rows;
    console.log(`Documents to generate: ${docs.length}\n`);

    // Clean
    console.log('Cleaning up previous uploads...');
    if (fs.existsSync(UPLOADS_ROOT)) {
      for (const entry of fs.readdirSync(UPLOADS_ROOT)) {
        const full = path.join(UPLOADS_ROOT, entry);
        if (entry.startsWith('.')) continue;
        if (entry !== '.gitkeep') fs.rmSync(full, { recursive: true, force: true });
      }
    }
    console.log('Cleanup complete.\n');

    const MIN_SIZES = {
      PROTOCOL: 500 * 1024, ICF: 250 * 1024, CV: 100 * 1024, PIS: 150 * 1024,
      IRB_APPROVAL: 120 * 1024, ETHICS_DECISION: 100 * 1024, APPROVAL_CERTIFICATE: 200 * 1024,
      FINAL_REPORT: 300 * 1024, MEETING_MINUTES: 150 * 1024, STUDY_PROPOSAL: 200 * 1024,
      DATA_COLLECTION: 100 * 1024, QUESTIONNAIRE: 80 * 1024, CRF: 100 * 1024,
      PUBLICATION: 250 * 1024, SOP: 80 * 1024, FUNDING: 50 * 1024, BUDGET: 50 * 1024,
      EVIDENCE_DOC: 100 * 1024, AMENDMENT_PKG: 200 * 1024, OTHER: 50 * 1024
    };

    let generated = 0, errors = 0, totalSize = 0;
    const typeStats = {}, sizeStats = { min: Infinity, max: 0 };

    for (const doc of docs) {
      const docType = doc.type_code;
      const appNum = doc.application_number;
      const appYear = doc.app_year || 2025;
      const title = doc.project_title || 'Research Study';
      const fileName = doc.file_name;
      const isArabic = /[\u0600-\u06FF]/.test(doc.document_title);

      let subDir;
      if (docType === 'APPROVAL_CERTIFICATE') subDir = path.join('certificates', String(appYear));
      else if (docType === 'EVIDENCE_DOC') subDir = path.join('evidence', String(appYear), appNum);
      else if (docType === 'AMENDMENT_PKG') subDir = path.join('amendments', String(appYear), appNum);
      else if (docType === 'FINAL_REPORT' || docType === 'PUBLICATION') subDir = path.join('reports', String(appYear), appNum);
      else subDir = path.join('applications', String(appYear), appNum);

      const fullDir = path.join(UPLOADS_ROOT, subDir);
      const fullPath = path.join(fullDir, fileName);
      fs.mkdirSync(fullDir, { recursive: true });

      try {
        let fileBuffer;

        switch (docType) {
          case 'PROTOCOL':
            fileBuffer = await makePdfkitDoc(CONTENT.protocolAr(title, 8) + '\n\n' + CONTENT.protocolEn(title, 8));
            break;
          case 'ICF':
            fileBuffer = await makePdfkitDoc(CONTENT.icfAr(title) + '\n\n---\n\n' + CONTENT.icfEn(title));
            break;
          case 'CV': {
            const name = doc.document_title.replace(/السيرة الذاتية - /g, '').replace(/Curriculum Vitae - /g, '').trim() || title;
            fileBuffer = await makePdfkitDoc(CONTENT.cv(name));
            break;
          }
          case 'PIS':
            fileBuffer = await makePdfkitDoc(CONTENT.pisAr(title) + '\n\n---\n\n' + CONTENT.pisEn(title));
            break;
          case 'QUESTIONNAIRE':
          case 'CRF':
          case 'DATA_COLLECTION':
            fileBuffer = await makePdfkitDoc(CONTENT.dataAr() + '\n\n---\n\n' + CONTENT.dataEn());
            break;
          case 'IRB_APPROVAL':
            fileBuffer = await makePdfkitDoc(CONTENT.irbAr(title) + '\n\n---\n\n' + CONTENT.irbEn(title));
            break;
          case 'FUNDING':
            fileBuffer = await makeFundingXLSX();
            break;
          case 'BUDGET':
            fileBuffer = await makeBudgetXLSX();
            break;
          case 'SOP':
            fileBuffer = await makePdfkitDoc(CONTENT.sop());
            break;
          case 'ETHICS_DECISION':
            fileBuffer = await makePdfkitDoc(CONTENT.ethicsAr(title) + '\n\n---\n\n' + CONTENT.ethicsEn(title));
            break;
          case 'MEETING_MINUTES':
            fileBuffer = await makePdfkitDoc(CONTENT.minutesAr() + '\n\n---\n\n' + CONTENT.minutesEn());
            break;
          case 'APPROVAL_CERTIFICATE': {
            const serial = `ERC-${appYear}-${String(doc.entity_id).padStart(5, '0')}`;
            const date = new Date().toLocaleDateString(isArabic ? 'ar-SA' : 'en-US');
            const holder = doc.document_title.replace(/شهادة اعتماد - /g, '').replace(/Approval Certificate - /g, '').trim() || 'Principal Investigator';
            const html = certHtml(serial, title, holder, date, isArabic);
            fileBuffer = await makeCertPDF(html);
            break;
          }
          case 'FINAL_REPORT':
            fileBuffer = await makePdfkitDoc(CONTENT.reportAr(title) + '\n\n---\n\n' + CONTENT.reportEn(title));
            break;
          case 'PUBLICATION':
            if (fileName.endsWith('.docx')) {
              const text = CONTENT.publication(title);
              fileBuffer = await makeDOCX(`Publication: ${title}`, text.split('\n').filter(l => l.trim()).map(l => l.replace(/^##?\s*/, '').replace(/^---.*/, '')));
            } else {
              fileBuffer = await makePdfkitDoc(CONTENT.publication(title));
            }
            break;
          case 'STUDY_PROPOSAL':
            fileBuffer = await makePdfkitDoc(CONTENT.proposalAr(title) + '\n\n---\n\n' + CONTENT.proposalEn(title));
            break;
          case 'EVIDENCE_DOC':
            if (fileName.match(/\.(jpg|jpeg|png)$/i)) {
              fileBuffer = makePNG(400, 300);
            } else {
              fileBuffer = await makePdfkitDoc(CONTENT.evidence(appNum, title));
            }
            break;
          case 'AMENDMENT_PKG':
            fileBuffer = await makePdfkitDoc(CONTENT.amendment(appNum, title));
            break;
          case 'OTHER':
            if (fileName.match(/\.(docx?)$/i)) {
              fileBuffer = await makeDOCX(`Supporting: ${title}`, [`Application: ${appNum}`, `Title: ${title}`, '', 'Additional supporting documentation.', '', `Date: ${new Date().toLocaleDateString('en-US')}`]);
            } else if (fileName.match(/\.(xlsx?|csv)$/i)) {
              fileBuffer = await makeXLSX([['Document ID', 'Type', 'Title', 'Application', 'Date'], [String(doc.id), docType, title, appNum, new Date().toISOString().split('T')[0]]], 'Documents');
            } else {
              fileBuffer = await makePdfkitDoc(`Supporting Document\nApplication: ${appNum}\nTitle: ${title}\n\nAdditional supporting documentation for the ethics review process.`);
            }
            break;
          default:
            fileBuffer = await makePdfkitDoc(`Document: ${docType}\nApplication: ${appNum}\nTitle: ${title}`);
        }

        // Pad to minimum size if needed
        const targetMin = MIN_SIZES[docType] || 50 * 1024;
        if (fileBuffer.length < targetMin) {
          const padSize = targetMin - fileBuffer.length + Math.floor(Math.random() * targetMin * 0.3);
          fileBuffer = Buffer.concat([fileBuffer, Buffer.alloc(padSize, ' ')]);
        }

        fs.writeFileSync(fullPath, fileBuffer);
        const sha256 = crypto.createHash('sha256').update(fileBuffer).digest('hex');
        const fileSize = fileBuffer.length;
        const newStoragePath = subDir.replace(/\\/g, '/') + '/' + fileName;

        await client.query(
          'UPDATE documents.documents SET checksum_sha256 = $1, file_size_bytes = $2, storage_path = $3 WHERE id = $4',
          [sha256, fileSize, newStoragePath, doc.id]
        );

        generated++;
        totalSize += fileSize;
        sizeStats.min = Math.min(sizeStats.min, fileSize);
        sizeStats.max = Math.max(sizeStats.max, fileSize);
        typeStats[docType] = (typeStats[docType] || 0) + 1;

        if (generated % 100 === 0) {
          console.log(`  ${generated}/${docs.length} files (${(totalSize/(1024*1024)).toFixed(1)} MB)`);
        }
      } catch (err) {
        errors++;
        console.error(`  ERROR [${doc.id}] ${doc.file_name}: ${err.message}`);
      }
    }

    console.log('\n=== GENERATION COMPLETE ===\n');
    console.log(`Total files: ${generated}`);
    console.log(`Errors: ${errors}`);
    console.log(`Total size: ${(totalSize / (1024*1024)).toFixed(2)} MB`);
    console.log(`Average: ${(totalSize / generated / 1024).toFixed(1)} KB`);
    console.log(`Smallest: ${(sizeStats.min / 1024).toFixed(1)} KB`);
    console.log(`Largest: ${(sizeStats.max / (1024*1024)).toFixed(2)} MB`);
    console.log('\nType distribution:');
    for (const [t, c] of Object.entries(typeStats).sort((a,b) => b[1] - a[1])) {
      console.log(`  ${t.padEnd(22)} ${String(c).padStart(4)} (${(c/generated*100).toFixed(1)}%)`);
    }
    console.log('\nDirectory tree:');
    printTree(UPLOADS_ROOT, 0, 2);

  } finally {
    if (certBrowser) await certBrowser.close();
    client.release();
    await pool.end();
  }
}

function printTree(dir, depth, maxDepth) {
  if (depth > maxDepth) return;
  try {
    for (const item of fs.readdirSync(dir, { withFileTypes: true })) {
      if (item.name.startsWith('.')) continue;
      if (item.isDirectory()) {
        const count = fs.readdirSync(path.join(dir, item.name)).length;
        console.log('  '.repeat(depth) + item.name + '/ (' + count + ' items)');
        printTree(path.join(dir, item.name), depth + 1, maxDepth);
      }
    }
  } catch(e) {}
}

main().catch(err => {
  console.error('FATAL:', err);
  if (certBrowser) certBrowser.close().catch(()=>{});
  process.exit(1);
});
