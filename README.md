Cancer Incidence and Mortality Prediction
🎯 Modeling Cancer Risk Using Demographic and Environmental Factors

This project builds predictive models to estimate cancer incidence and death rates using features like demographic distribution, socioeconomic indicators, healthcare access, and behavioral factors from a public dataset. The goal is to identify key predictors and evaluate model performance using regression and classification techniques.
📌 Project Highlights

    ✅ Preprocessed real-world cancer dataset with 50+ features

    🧠 Built and evaluated regression models to predict cancer death rates

    🔍 Feature selection using correlation analysis & multicollinearity checks

    📉 Applied Linear Regression, Random Forest, and Gradient Boosting

    📊 Visualized correlations, feature importances, and prediction accuracy

🧰 Tech Stack

    Python, Pandas, NumPy

    Scikit-learn, XGBoost, Seaborn, Matplotlib

    Jupyter Notebook

⚙️ How to Run

# 1. Clone the repository
git clone https://github.com/hrhaditya/-Create-a-model-of-cancer-incidence-death-using-the-factors-in-this-dataset..git
cd cancer-modeling

# 2. Install dependencies
pip install -r requirements.txt

# 3. Open the notebook
jupyter notebook cancer_modeling.ipynb

📈 Sample Results
Model	R² Score	RMSE	Key Notes
Linear Regression	0.68	5.7	Interpretable but underfit
Random Forest	0.82	4.2	Strong accuracy, less interpret.
Gradient Boosting	0.84	4.0	Best overall performance
💡 Key Insights

    Smoking prevalence, poverty rate, and access to healthcare were top predictors of cancer mortality.

    Ensemble models (like Gradient Boosting) provided the best balance between accuracy and generalization.

📄 License

MIT License
👤 Author

Harshaditya Kumar Mallipudi
