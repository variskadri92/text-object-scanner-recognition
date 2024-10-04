import pickle
import joblib
import os
import numpy as np
import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from string import punctuation
import pytesseract
from PIL import Image
import re
from flask import Flask, request, jsonify

app = Flask(__name__)

# Load the model and vectorizer once at the start
with open(r'D:\Flutter Projects\text-object-scanner-recognition\api\naive_bayes_model.pkl', 'rb') as model_file:
    model = pickle.load(model_file)
    
vectorizer = joblib.load(r'D:\Flutter Projects\text-object-scanner-recognition\api\vectorizer.pkl')

# Route to handle image processing and classification
@app.route('/process', methods=['POST'])
def process_image():
    if 'image' not in request.files:
        return jsonify({"error": "No image provided"}), 400

    # Load image and perform OCR to extract text
    image = request.files['image']
    img = Image.open(image)
    ocr_result = pytesseract.image_to_string(img)

    # Preprocess the extracted text
    stopwords_list = stopwords.words("english")

    def data_preprocess(text):
        text = text.lower()
        text = text.replace("\n", " ").replace("\t", " ")
        text = re.sub(r"\s+", " ", text)
        text = re.sub(r"\d+", "", text)
        text = re.sub(r"[^\w\s]", "", text)

        tokens = word_tokenize(text)
        data = [i for i in tokens if i not in punctuation]
        data = [i for i in data if i not in stopwords_list]

        lemmatizer = WordNetLemmatizer()
        final_text = [lemmatizer.lemmatize(i) for i in data]

        return " ".join(final_text)

    preprocessed_input = data_preprocess(ocr_result)
    vectorize_input = vectorizer.transform([preprocessed_input])

    # Make a prediction
    predict_label = model.predict(vectorize_input)[0]

    # Define class labels (ensure this matches your model's output)
    class_labels = {0: 'email', 1: 'resume', 2: 'scientific_publication', 3: 'Question_ppr'}

    # Convert the prediction to the corresponding label
    predicted_class = class_labels.get(predict_label, "Unknown")

    # Return both OCR text and predicted class as a JSON response
    return jsonify({"ocr_text": ocr_result, "predicted_class": predicted_class})

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
