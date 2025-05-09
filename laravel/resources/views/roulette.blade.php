<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>ルーレット</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
    <div class="text-center p-4 max-w-md w-full">
        <h1 class="text-3xl font-bold mb-4">今日のランチは何にする？</h1>

        <div id="fieldsContainer" class="mb-4 space-y-2">
            <input type="text" class="input input-bordered w-full option-field" placeholder="選択肢1">
        </div>

        <button id="addFieldButton" class="btn btn-secondary mb-4 w-full">選択肢を追加</button>
        <button id="startButton" class="btn btn-primary w-full">スタート！</button>

        <div id="result" class="mt-6 text-2xl font-semibold"></div>
    </div>

    <script>
        const fieldsContainer = document.getElementById('fieldsContainer');
        const addFieldButton = document.getElementById('addFieldButton');
        const startButton = document.getElementById('startButton');
        const resultDiv = document.getElementById('result');

        addFieldButton.addEventListener('click', () => {
            const newInput = document.createElement('input');
            newInput.type = 'text';
            newInput.className = 'input input-bordered w-full option-field';
            newInput.placeholder = `選択肢${fieldsContainer.children.length + 1}`;
            fieldsContainer.appendChild(newInput);
        });

        startButton.addEventListener('click', () => {
            const optionFields = document.querySelectorAll('.option-field');
            const options = Array.from(optionFields)
                .map(input => input.value.trim())
                .filter(value => value);

            if (options.length === 0) {
                resultDiv.textContent = 'まず1つ以上の選択肢を入力してください！';
                return;
            }

            const randomIndex = Math.floor(Math.random() * options.length);
            resultDiv.textContent = `選ばれたのは… ${options[randomIndex]}！`;
        });
    </script>
</body>
</html>
