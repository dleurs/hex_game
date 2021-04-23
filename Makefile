build-web: ## new-flutter because I am currently working with two versions of flutter, flutter 1.22.6 and up-to-date new-flutter
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