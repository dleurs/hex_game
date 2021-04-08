build-web: ## new-flutter because I am currently working with two versions of flutter, flutter 1.22.6 and up-to-date new-flutter
	new-flutter build web --release --no-sound-null-safety; 

firebase-login:
	firebase login

firebase-deploy:
	firebase deploy

deploy-web: build-web firebase-deploy 
	echo "\nDo not forget git push\n"
	
generate-intl: ## Generate localization file
	new-flutter pub run intl_utils:generate