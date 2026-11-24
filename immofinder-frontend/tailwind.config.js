/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: '#5B21B6', // Le violet de vos maquettes
        'primary-light': '#7C3AED',
        background: '#F9FAFB',
      },
      fontFamily: {
        sans: ['Poppins', 'sans-serif'], // Police moderne
      }
    },
  },
  plugins: [],
}