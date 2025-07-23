# 🌧 Linux For My DevOps Journey

Hey there — welcome to my little Linux lab.
This repo documents my hands-on journey mastering (but not perfecting) Linux for DevOps. It includes the rough challenges, small wins, resources I uncovered, and the habits I'm building to become proficient in Linux system administration, terminal navigation, and automation tooling.
If you're curious about Linux fundamentals and not worried about the rough edges of learning and becoming, this space is my two cents.

---

## 🛠 How to Use This Repo

This isn't a textbook. It's a live record of learning, mistakes, and growth. Here's how you can use it:

* **Browse freely:** Each folder represents a part of my journey (wargames, projects, debugging challenges, etc.)
* **Read through the reflections:** They give context on what I learned and struggled with
* **Use the notes and scripts as references:** Not perfect, but practical
* **Steal like a learner:** If anything helps you understand Linux better, copy it, remix it, improve it
* **Track my progress:** Follow the commit history and folders as I build up my system-level skills

---

## 📌 What’s Inside

* 🧠 Linux notes (probably messy 😵‍💫) & key commands
* 🔹 OverTheWire Bandit walkthrough (Levels 0–20)
* 🚰 SadServers break-fix debug reports
* 🎮 Bash Battle Arena game & walkthrough
* 🧮 My calculator project — terminal-based & built from scratch
* 🪞 Reflections: wins, lessons, and friction points
* 🔗 LinkedIn posts and dev journal entries
* 🎯 Curated resources that actually helped me learn

---

## 🚀 Goals

* Reflect and write publicly on what I learn (a challenge I've been taking on recently)
* Familiarize myself with Linux basics to advanced: file system, permissions, processes, shell config, CLI tools
* Complete some levels of the Bandit game and make some SadServers happy (hopefully 🤞)
* Explore Bash scripting through the Bash Battle Arena challenges
* Use GitHub as a living record of my growth

---

## 🧮 Calculator Project

📁 `projects/calculator.sh`

This mini-project helped reinforce:

* Bash scripting & flow control
* Handling user input
* Arithmetic expressions
* Exit codes

> Simple, but solid. Check it [here](https://github.com/AhmedMHCodeLab/My-CoderCo-Hub/tree/main/Linux/Octal%20chmod%20Calculator).

---

## 🔹 OverTheWire Bandit

📁 `bandit-notes/`

This wargame took me through layered Linux challenges, each building on the last. From basic navigation to using SSH keys, decoding hex, and dealing with file permission traps — it was brilliant.

I completed Levels 0–20:

* Commands used
* Lessons learned
* Missteps and how I fixed them

> Best part? It turned “just typing commands” into *thinking through challenges*.

---

## 🧹 SadServers Debug Challenges

📁 `sadservers/`

SadServers put me in real-world-ish break-fix situations where servers were broken and I had to figure out *why* — and how to fix them, fast (recommended).

### Things I fixed:

* Broken SSH services due to wrong shell defaults
* Misconfigured systemd services
* Missing environment variables and startup failures
* Firewalls blocking traffic between internal services

### Why it mattered:

These made me think diagnostically, not just memorizing commands — and they definitely sharpened my system-level troubleshooting instincts.

> Bonus: I now log every fix, thought process, and lessons learned in the `sadservers/` directory.

---

## 🎮 Bash Battle Arena

📁 `bash-battle-arena/`

A level-based, CLI-focused Bash scripting game. Created by CoderCO, this game helped stretch my scripting muscle in fun, challenge-packed missions.

Every 5 levels, a Boss Battle combines prior skills. Solutions are submitted via GitHub, with future scoring features incoming.

### Sample Levels:

* Level 1: Create directory and files in `Arena/`
* Level 3: Check for `hero.txt` and report status
* Level 5 Boss: Create, check, move, and list contents of multiple directories
* Level 10 Boss: Generate random data, search files, move winners to archive
* Level 15 Boss: Present interactive menu for multiple system tasks

> A great mix of fun and function. Leveling up has never been so CLI-focused.

---

## 🧠 Reflections & Real Talk

### ✅ Wins

* Finally understood symbolic vs numeric `chmod` (and how to use both).
* Used `tmux` and `zsh` like a pro — my shell feels like *mine* now.
* Learned to debug misbehaving Linux servers (SadServers = 💥).
* Created my own Bash CLI tool (the calculator).

### ⚠️ Challenges

* Accidentally locked myself out with `.zshrc` config — learned the power of fallback shells.
* Tripped over `PATH` and `$HOME` issues during SadServer challenges.
* Took some time to internalize stream redirection and pipes.

---

## 🔗 LinkedIn Posts

These are my public logs where I shared challenges, takeaways, and encouragement for other DevOps learners:

((Have to fetch them — give me time 😅👍))

---

## 📚 Favorite Resources

### 👥 CoderCO Community (The Ultimate Resource)

* This community is where all the magic happens: [CoderCO Skool](https://www.skool.com/coderco/about?ref=496b29bcf7ef44d080dccfb972a4d019)

### 🎥 YouTube Videos

((To be fetched soon 😅👍))

### 🎮 Practice Platforms

* [OverTheWire: Bandit](https://overthewire.org/wargames/bandit/)
* [SadServers](https://sadservers.com/)
* [Killercoda Labs](https://killercoda.com/)
* Bash Battle Arena — \[designed by CoderCO]

### 🧾 Docs & Helpers

((Also coming soon 😅👍))

---

## 📁 Repo Structure

```
📁 linux-devops-journey/
├── 📂 projects/
│   └── calculator.sh
├── 📂 bandit-notes/
│   └── level-00-to-20.md
├── 📂 sadservers/
│   ├── ssh-fix.md
│   ├── systemd-debug.md
│   └── firewall-issue.md
├── 📂 bash-battle-arena/
│   ├── level01-basics.sh
│   ├── level05-boss.sh
│   └── level15-boss.sh
├── 📂 reflections/
│   ├── wins.md
│   └── challenges.md
├── 📂 resources/
│   ├── videos.md
│   ├── tools.md
│   └── posts.md
└── README.md
```

---

## 🏁 Final Note

This repo isn't a "look at how perfect I am" project. It’s raw, real, and representative of learning in motion.
If you're on the DevOps path, hopefully it gives you clarity, hope, or even a template to make your own.

—
Ahmed
