build-web: 
	/Users/dle/Documents/Flutter/Software/new-flutter/bin/flutter build web --release --no-sound-null-safety; 

firebase-login:
	firebase login

firebase-deploy:
	firebase deploy

deploy-web: build-web firebase-deploy
	echo "\nDo not forget git push\n"
	
generate-intl: ## Generate localization file
	/Users/dle/Documents/Flutter/Software/new-flutter/bin/flutter pub run intl_utils:generate

generate-model: ## Generate Json serialization for model classes and GraphQL classes from graphql files
	/Users/dle/Documents/Flutter/Software/new-flutter/bin/flutter pub run build_runner build --delete-conflicting-outputs

drive-test:
	/Users/dle/Documents/Flutter/Software/new-flutter/bin/flutter drive --target=test_driver/app.dart

# drive-test-web:
# 	/Users/dle/Documents/Flutter/Software/utils/chromedriver --port=4444
# 	/Users/dle/Documents/Flutter/Software/new-flutter/bin/flutter drive --target=test_driver/app.dart --browser-name=chrome --release