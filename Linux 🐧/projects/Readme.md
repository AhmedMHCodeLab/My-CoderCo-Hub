# 🐧 Linux For My DevOps Journey

Hey there — welcome to my little Linux lab.
This repo documents my hands-on journey mastering (but not perfection) Linux for DevOps. It rough challenges, small wins, resources I uncovered, 
and the habits I'm building to become proficient in Linux system administration, terminal navigation, and automation tooling.
If you're curious about linux fundamentals and not worried about rough edges of learning and becoming, this space is my two cents.

---

## 📌 What’s Inside

- 🧠 Linux notes (probably messy😵‍💫) & key commands  
- 🕹 OverTheWire Bandit walkthrough (Levels 0–20)  
- 🛠 SadServers break-fix debug reports  
- 🧮 My calculator project — terminal-based & built from scratch  
- 🪞 Reflections: wins, lessons, and friction points  
- 🔗 LinkedIn posts and dev journal entries  
- 🎯 Curated resources that actually helped me learn

---

## 🚀 Goals

- Reflect and write publicly on what I learn (a challenge i've been taking on recently)
- Familrize myself with Linux basics to advanced: file system, permissions, processes, shell config, CLI tools  
- Complete some levels of the Bandit game and make some SadServers happy(hopefully🤞).  
- Use GitHub as a living record of my growth

---

## 🧮 Calculator Project

📁 `projects/calculator.sh`

This mini-project helped reinforce:
- Bash scripting & flow control
- Handling user input
- Arithmetic expressions
- Exit codes

> Simple, but solid. Check it [here](https://github.com/AhmedMHCodeLab/My-CoderCo-Hub/tree/main/Linux/Octal%20chmod%20Calculator).

---
## 🕹 OverTheWire Bandit (https://overthewire.org/wargames/bandit/)

📁 `bandit-notes/`

This wargame took me through layered Linux challenges, each building on the last. From basic navigation to using SSH keys, decoding hex, and dealing with file permission traps — it was brilliant.

I completed Levels 0–20:
- Commands used  
- Lessons learned  
- Missteps and how I fixed them

> Best part? It turned “just typing commands” into *thinking through challenges*.

---

## 🧩 SadServers Debug Challenges (https://sadservers.com)

📁 `sadservers/`

SadServers put me in real-world-ish break-fix situations where servers were broken and I had to figure out *why* — and how to fix them, fast (recommended).

### Things I fixed:
- Broken SSH services due to wrong shell defaults  
- Misconfigured systemd services  
- Missing environment variables and startup failures  
- Firewalls blocking traffic between internal services  

### Why it mattered:
These made me think diagnostically, not just memorizing commands and they definitely sharpened my system-level troubleshooting instincts.

> Bonus: I now log every fix, thought process, and lessons learned in the `sadservers/` directory.

---

## 🧠 Reflections & Real Talk

### ✅ Wins
- Finally understood symbolic vs numeric `chmod` (and how to use both).
- Used `tmux` and `zsh` like a pro — my shell feels like *mine* now.
- Learned to debug misbehaving Linux servers (SadServers = 💥).
- Created my own Bash CLI tool (the calculator).

### ⚠️ Challenges
- Accidentally locked myself out with `.zshrc` config — learned the power of fallback shells.
- Tripped over `PATH` and `$HOME` issues during SadServer challenges.
- Took some time to internalize stream redirection and pipes.

---

## 🔗 LinkedIn Posts

These are my public logs where I shared challenges, takeaways, and encouragement for other DevOps learners:

((Have to fetch them give me time yeah 😅👍))


---

## 📚 Favorite Resources

### 👥CoderCO Community (The Ulitmate Resource)
- This community is where all the magic happens (https://www.skool.com/coderco/about?ref=496b29bcf7ef44d080dccfb972a4d019)

### 🎥 YouTube Videos
((Have to fetch those too give me time... 😅👍))

### 🎮 Practice Platforms
- [OverTheWire: Bandit](https://overthewire.org/wargames/bandit/)
- [SadServers](https://sadservers.com/)
- [Killercoda Labs](https://killercoda.com/)

### 🧾 Docs & Helpers
((And to be fetched too give me time pls 😅👍))

---

## 📁 Repo Structure

📁 linux-devops-journey/
├── 📂 projects/
│ └── calculator.sh
├── 📂 bandit-notes/
│ └── level-00-to-20.md
├── 📂 sadservers/
│ ├── ssh-fix.md
│ ├── systemd-debug.md
│ └── firewall-issue.md
├── 📂 reflections/
│ ├── wins.md
│ └── challenges.md
├── 📂 resources/
│ ├── videos.md
│ ├── tools.md
│ └── posts.md
├── README.md

---

## 🏁 Final Note

This repo isn't a "look at how perfect I am" project. It’s raw, real, and representative of learning in motion.
If you're on the DevOps path, hopefully it gives you clarity, hope, or even a template to make your own.

—
Ahmed


