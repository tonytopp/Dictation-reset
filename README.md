# Dictation Reset – macOS

**En enkel menyradsapp som startar om ljud- och dikteringstjänster på Mac.**

Har du problem med att diktering eller mikrofon slutar fungera på macOS? Med denna app kan du med ett klick återställa alla nödvändiga tjänster – utan att behöva starta om datorn!

---

## 🚀 Funktioner
- Menyradsikon för snabb åtkomst
- Startar om alla relevanta tjänster (coreaudiod, corespeechd m.fl.)
- Fungerar på macOS Sonoma, Ventura, Monterey m.fl.
- Enkel installation

## 📦 Installation

1. **Klona repot**
   ```bash
   git clone https://github.com/tonytopp/Dictation-reset.git
   cd Dictation-reset
   ```

2. **Installera Python-bibliotek**
   ```bash
   pip3 install --user rumps
   ```

3. **Starta menyradsappen**
   ```bash
   python3 restart_audio_menu.py
   ```

4. **(Rekommenderat) Lägg till som startapp**
   - Se instruktioner längre ner i README.

---

## ☕️ Stötta projektet!

Om du uppskattar denna lösning får du gärna bjuda på en kaffe:  
[buymeacoffee.com/topptony02c](https://buymeacoffee.com/topptony02c)

---

## 🖼️ Skärmdumpar

*(Lägg gärna in en bild på menyradsikonen här!)*

---

## 📝 Licens
MIT License

---

## ❓ Vanliga frågor

**F: Vad gör scriptet?**  
S: Det startar om systemtjänster som ibland låser sig och gör att diktering/mikrofon slutar fungera.

**F: Är det säkert?**  
S: Ja, scriptet startar bara om tjänster – inget annat.

**F: Kan jag bidra?**  
S: Pull requests och förbättringsförslag välkomnas!

---

## 💡 Tips för autostart

Vill du att appen ska starta automatiskt vid inloggning?

1. Skapa en Automator-app:
   - Öppna Automator, välj "App".
   - Lägg till åtgärden "Kör kommandotolkskript".
   - Klistra in: `/usr/bin/python3 /Users/tonytopp/Dictation-reset/restart_audio_menu.py`
   - Spara som t.ex. `Starta Diktering.app`.

2. Lägg till Automator-appen under **Systeminställningar → Allmänt → Inloggningsobjekt**.

---

*By Tony Topp – inspirerad av ett riktigt macOS-problem!*
