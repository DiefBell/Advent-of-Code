/** @type {import("eslint").Linter.Config} */
const config = {
	extends: [
		"../../node_modules/@dief/prefs/eslintrc/core.cjs",
	],
	rules: {
		"no-console": "off",
		"@stylistic/brace-style": ["warn", "1tbs"], // I hate it buts it's what JS devs use 🤢
	},
};

module.exports = config;
