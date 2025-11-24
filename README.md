# The-Truth-Daily
A verse of the day in a command>promise>rights format 

## Screenshots
![Home Screen](assets/screenshots/home_screen.png) - Daily verse view with audio buttons.
![Loading State](assets/screenshots/loading.png) - Spinner on load.
![Error Retry](assets/screenshots/error.png) - Handling fetch fails.

Take/upload your own: Run app (\`flutter run\`), screenshot, place in assets/screenshots.

### Deployment to GitHub Pages

1. Add `API_BIBLE_KEY` as repo secret: Settings > Secrets and variables > Actions > New repository secret.
2. Push to main: Triggers workflow auto (builds web, deploys to gh-pages).
3. View: https://devinmylegacy.github.io/The-Truth-Daily/ (set Pages source to gh-pages/root in Settings > Pages).

