import pytesseract
from PIL import Image
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/api', methods=['POST'])
def img_text():
    if 'image' not in request.files:
        return jsonify({"error": "No image provided"}), 400
    image = request.files['image']
    img = Image.open(image)
    ocr_result = pytesseract.image_to_string(img)
    return jsonify({"text": ocr_result})

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
