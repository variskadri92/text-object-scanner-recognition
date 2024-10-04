import pickle
import joblib
import os 
import pandas as pd
import numpy as np
import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import LancasterStemmer, WordNetLemmatizer
from string import punctuation
import pytesseract
from PIL import Image
import re
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import accuracy_score, classification_report
from sklearn.feature_extraction.text import TfidfVectorizer,CountVectorizer

with open(r'D:\Flutter Projects\text-object-scanner-recognition\api\naive_bayes_model.pkl', 'rb') as model_file:
    model = pickle.load(model_file)

vectorizer = joblib.load(r'D:\Flutter Projects\text-object-scanner-recognition\api\vectorizer.pkl')

path=r"C:\Users\ygwor\Downloads\WhatsApp Image 2024-10-03 at 16.34.57.jpeg"
image=Image.open(path)
txt= pytesseract.image_to_string(image)
txt
stopwords_list=stopwords.words("english")
def data_preprocess(text):
    text=text.lower()
    
    # replacing new line and tab character in text with a space
    text=text.replace("\n"," ").replace("\t"," ")

    # replacing more than one space with a single space
    text=re.sub(r"\s+"," ",text)

    # removes any sequence of digit from the text
    text=re.sub(r"\d+","",text)

    #remove all punctuation and special characters from the text
    text=re.sub(r"[^\w\s]","",text)

    # Converting the cleaned text into individual tokens(words)
    tokens= word_tokenize(text)

    # filtering out any punctuation and stopwords from the list of tokens
    data=[i for i in tokens if i not in punctuation]
    data=[i for i in data if i not in stopwords_list]

    # Lemmatization is the process of reducing a word to its base or root form 
    # (known as the lemma), but unlike stemming, it ensures the word remains meaningful 
    # and grammatically correct.
    lemmatizer=WordNetLemmatizer()
    final_text=[]
    for i in data:
        # applying lemmatization to each word in the data list.
        word=lemmatizer.lemmatize(i)
        final_text.append(word)
    return " ".join(final_text)

preprocessed_input=data_preprocess(txt)
vectorize_input=vectorizer.transform([preprocessed_input])

predict_label=model.predict(vectorize_input)

class_labels={'email':0,'resume':1,'scientific_publication':2,'Question_ppr':3}

print(predict_label)