<img src="https://fit.cvut.cz/static/images/fit-cvut-logo-en.svg" alt="FIT CTU logo" height="200">

This software was developed with the support of the **Faculty of Information Technology, Czech Technical University in Prague**.
For more information, visit [fit.cvut.cz](https://fit.cvut.cz).

***

# Artificial Intelligence Projects

A collection of projects completed as part of an **Artificial Intelligence** university course. The repository covers several core AI topics, including expert systems, automated reasoning, probabilistic graphical models, and machine learning.

Each project focuses on a different AI technique and includes both the implementation and documentation explaining the underlying algorithms.

---

## Repository Structure

```text
.
├── task_01   # Expert system in Prolog
├── task_02   # Forward chaining inference engine
├── task_03   # Bayesian networks
├── task_04   # Rule extraction from Random Forests
└── README.md
```

---

## Projects

### Task 1 — Expert System in Prolog

An expert system implemented in **Prolog** for validating receipts using a rule-based knowledge base.

The project demonstrates:

* Horn clause programming
* Rule-based reasoning
* Interactive expert systems
* Knowledge representation
* Receipt validation

**Highlights**

* Interactive question-based reasoning
* Automatic validation of company identification numbers (IČO)
* Minimal questioning by remembering previously derived facts
* Test dataset included

📁 **Directory:** [`task_01`](./task_01)

---

### Task 2 — Forward Chaining Inference Engine

An implementation of a **forward chaining** inference engine capable of deriving all inferable facts from a knowledge base.

The implementation includes:

* Forward chaining
* Variable unification
* Rule matching
* Knowledge base expansion
* Parser for logical rules

The implementation follows the forward chaining approach presented in *Artificial Intelligence: A Modern Approach (AIMA)*.

📁 **Directory:** [`task_02`](./task_02)

---

### Task 3 — Bayesian Networks

Construction and refinement of Bayesian Networks for classification using **OpenMarkov**.

The project explores multiple approaches to structure learning:

* Hill Climbing
* PC algorithm
* Interactive refinement
* Manual optimization

The resulting models are compared and gradually refined into a final Bayesian Network.

📁 **Directory:** [`task_03`](./task_03)

---

### Task 4 — Rule Extraction from Random Forests

Machine learning project focused on converting a trained **Random Forest** into a compact, interpretable rule set.

Pipeline:

1. Data preprocessing
2. Random Forest training
3. Rule extraction
4. Hill Climbing optimization
5. Evaluation

The final rule set reduces approximately **1000 rules** to **69** while maintaining nearly identical classification accuracy.

📁 **Directory:** [`task_04`](./task_04)

---

## Algorithms Covered

* Expert Systems
* Knowledge Representation
* Horn Clauses
* Forward Chaining
* Unification
* Bayesian Networks
* Hill Climbing
* PC Structure Learning
* Decision Trees
* Random Forests
* Rule Extraction

---

## Technologies

* Python
* Prolog (SWI-Prolog)
* Jupyter Notebook
* OpenMarkov
* scikit-learn
* NumPy
* pandas
* Matplotlib

---

## Visual Overview

### Forward Chaining

<p align="center">
<img src="task_02/images/forward_chaining.png" width="700">
</p>

---

### Bayesian Network

Full Bayesian Network:

<p align="center">
<img src="task_03/images/bayes_net_hc.png" width="700">
</p>

Optimized:

<p align="center">
<img src="task_03/images/bayes_net_final.png" width="700">
</p>

---

### Rule Extraction from Random Forest

A tree in a trained Random Forest:

<p align="center">
<img src="task_04/images/tree_example.png" width="700">
</p>

Algorithm for rules extraction:

<p align="center">
<img src="task_04/images/algorithm_rf_hc.png" width="700">
</p>

---

## Learning Outcomes

These projects demonstrate practical applications of several fundamental AI techniques:

* rule-based expert systems
* automated logical inference
* probabilistic graphical models
* Bayesian reasoning
* machine learning
* model interpretability
* rule extraction from ensemble models

Each project is self-contained and includes its own documentation with implementation details, methodology, and assignment description.

---

## License

This repository was created for educational purposes as part of university coursework.
