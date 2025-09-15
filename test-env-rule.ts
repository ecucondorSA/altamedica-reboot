// Test file to verify ESLint rule for process.env restriction
const apiUrl = process.env.NEXT_PUBLIC_API_URL;
console.log(apiUrl);
export {};