flutter run -d chrome --dart-define=GEMMA_API_KEY=$(grep GEMMA_API_KEY .env | cut -d "=" -f2)
