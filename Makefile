build-web: 
	flutter build web --release --no-sound-null-safety;

firebase-login:
	firebase login

firebase-deploy:
	firebase deploy

deploy-web: build-web firebase-deploy 
	echo "\nDo not forget git push\n"
	
generate-intl: ## Generate localization file
	flutter pub run intl_utils:generate