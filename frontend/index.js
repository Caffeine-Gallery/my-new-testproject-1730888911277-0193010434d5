import { backend } from 'declarations/backend';

const display = document.getElementById('display');
const loading = document.getElementById('loading');

window.appendToDisplay = (value) => {
    display.value += value;
};

window.clearDisplay = () => {
    display.value = '';
};

window.calculate = async () => {
    const expression = display.value;
    if (!expression) return;

    loading.style.display = 'block';
    try {
        const result = await backend.calculate(expression);
        display.value = result;
    } catch (error) {
        display.value = 'Error';
        console.error('Calculation error:', error);
    } finally {
        loading.style.display = 'none';
    }
};
