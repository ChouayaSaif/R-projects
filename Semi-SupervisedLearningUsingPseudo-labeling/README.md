readme_content <- "
# Semi-Supervised Learning on Mercedes-Benz Greener Manufacturing Dataset

## Overview
This project applies **semi-supervised learning** using **Pseudo-labeling** to predict the car testing time (`y`) in the **Mercedes-Benz Greener Manufacturing dataset**. The dataset consists of categorical and numerical features, and our goal is to optimize predictions using both labeled and unlabeled data.

## Dataset
- **`train.csv`**: Contains feature columns (`X0` to `X8` and others) and the target variable (`y`).
- **`test.csv`**: Contains only feature columns (without `y`), where we predict `y` values.

## Methodology
1. **Preprocessing**:
   - Remove `ID` column.
   - Handle missing values.
   - Encode categorical variables as numeric.
2. **Splitting Data**:
   - Use a small portion (20%) of the labeled training data.
   - Keep the rest as unlabeled data.
3. **Train an Initial Model**:
   - Use **XGBoost** on the labeled data.
4. **Pseudo-labeling**:
   - Predict labels (`y`) for the unlabeled data.
   - Select the most confident predictions.
   - Merge them with labeled data for training.
5. **Final Model Training & Prediction**:
   - Retrain on the expanded dataset.
   - Predict `y` values for the `test.csv` file.
   - Save the results in `submission.csv`.

## Dependencies
Ensure you have the following R packages installed:
\`\`\`r
install.packages(c(\"tidyverse\", \"caret\", \"xgboost\", \"data.table\"))
\`\`\`

## Running the Project
1. Load `train.csv` and `test.csv` into the working directory.
2. Run the script.
3. The output file `output.csv` will contain the predicted values.
