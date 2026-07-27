# 🎓 UniSync AI — FYP & Teammate Matcher

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Google Gemini](https://img.shields.io/badge/Google%20Gemini-8E75B2?style=for-the-badge&logo=googlecloud&logoColor=white)
![Vercel](https://img.shields.io/badge/Vercel-000000?style=for-the-badge&logo=vercel&logoColor=white)

> **UniSync AI** is an intelligent academic matchmaking and project planning dashboard designed for university students (such as at UOG) looking for compatible Final Year Project (FYP) partners and structured project execution strategies.

---

## 🔗 Deployed Live App
* **Public Web Link:** [https://unisync-ai.vercel.app](https://unisync-ai.vercel.app) *(Replace with your live Vercel link once deployed)*

---

## 🎯 Real Problem Addressed

### **The Problem:**
At universities, students facing Final Year Projects (FYPs) frequently struggle with two major hurdles:
1. **Finding Compatible Teammates:** Students often pick friends rather than peers with complementary skill sets (e.g., pairing two frontend designers together while lacking database/backend skills).
2. **Lack of Project Roadmap:** Ideas are often vague, leading to chaotic execution, missed deadlines, and poor supervisor reviews.

### **Target Audience:**
University undergraduate students, FYP committee coordinators, and academic advisors.

### **The Solution:**
UniSync AI acts as an automated project advisor. By analyzing a student's technical background and project concept, the AI instantly evaluates skill gaps, recommends the exact technical roles needed on the team, and builds an actionable 4-phase milestone roadmap.

---

## ✨ Key Features

- **🔒 Student Portal Authentication:** Modern dark-themed login and registration interface for university students.
- **📝 FYP Profile & Brief Collector:** Form interface for students to input their name, primary tech stack (e.g., Flutter, Python, Firebase), and project idea.
- **🧠 AI Teammate Matcher:** Evaluates student strengths and generates a 2-sentence partner strategy highlighting required complementary skill sets.
- **🎯 Technical Role Identification:** Auto-generates role badges for 3 specialized technical roles needed on the team (e.g., *Backend & Database Engineer*, *UI/UX Lead*, *ML Specialist*).
- **🗺️ Interactive 4-Phase Roadmap:** Automatically structures the project into clear, sequential execution milestones from initial design to thesis writing.
- **🎨 Sleek Dark UI Dashboard:** Designed with a professional Deep Slate Navy (`#0F172A`) base and vibrant Emerald Green (`#10B981`) accents.

---

## 🤖 AI Feature & System Prompt

UniSync AI uses the **Google Gemini 1.5 Flash API** (`gemini-1.5-flash`) to process student profiles and return strictly formatted JSON output for render-ready UI cards.

### **System Prompt Instructions:**

```text
You are an academic project advisor for university students. 
Analyze the student profile:
Student Name: {studentName}
Skills/Tech Stack: {skills}
Project Idea: {projectIdea}

Return ONLY valid JSON with keys:
1. "compatibility_summary": A 2-sentence summary of the required partner profile.
2. "required_roles": A list of 3 specific technical roles needed.
3. "project_roadmap": A list of 4 maps, each with "stage" (String) and "task" (String).
4. "suggested_tags": A list of 4 hashtag strings.

### **🛠️ Tools, Services & AI Models**
Frontend Framework: Flutter (Dart) — Web Release

AI Model: Google Gemini 1.5 Flash via Google AI Studio REST API

Networking: http Dart package for REST API communication

Hosting & Deployment: Vercel

Version Control: GitHub

**📸 App Screenshots
**
**login/signup**
<img width="622" height="886" alt="image" src="https://github.com/user-attachments/assets/36c10865-7ea2-4acc-8011-938121539415" />
**information collect<img width="620" height="840" alt="image" src="https://github.com/user-attachments/assets/9ffabc43-79a6-4c5a-b2ae-1254aa2e5a45" />
or**
**ai playing role**

<img width="623" height="872" alt="image" src="https://github.com/user-attachments/assets/bfd0e8eb-27cb-4b9e-8c9b-2377b32d4564" />

1. Student Auth View,2. FYP Concept Form,3. AI Roadmap Dashboard
Login & Signup UI,Profile Input Form,Generated Execution Strategy

🚀** How to Run the Project Locally**
Prerequisites:
Flutter SDK installed (version 3.x or higher)

Google Chrome Browser installed

Step-by-Step Setup:
Clone the repository:

**Bash**
git clone [https://github.com/nayabamna770-art/unisync_ai.git](https://github.com/nayabamna770-art/unisync_ai.git)
cd unisync_ai
Install dependencies:

Bash
flutter pub get
Set up API Key:
Open lib/main.dart and replace YOUR_GEMINI_API_KEY_HERE with your active Gemini API key from Google AI Studio.

**Launch on Web (Chrome):**

**Bash**
flutter run -d chrome
📄 License & Attribution
Developed as an individual final project submission for the AI Web Development Course (Batch 2 - UOG Mandi Bahauddin Campus).


---

### Push this to GitHub right now:

Run these commands in your VS Code terminal:

```bash
git add README.md
git commit -m "Update README with complete project report and rubrics"
git push -u origin main


