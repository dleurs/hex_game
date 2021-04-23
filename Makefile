build-web: ## new-flutter because I am currently working with two versions of flutter, flutter 1.22.6 and up-to-date new-flutter
	/Users/dle/Documents/Flutter/Software/new-flutter/bin/flutter build web --release --no-sound-null-safety; 

firebase-login:
	firebase login

firebase-deploy:
	firebase deploy

local-to-online: ## Remove '' for linux
	sed -i '' "s/firebase_keys_local.js/firebase_keys_online.js/" web/index.html; 

cat-index:
	cat web/index.html; 

online-to-local:
	sed -i '' "s/firebase_keys_online.js/firebase_keys_local.js/" web/index.html;

deploy-web: local-to-online cat-index build-web firebase-deploy online-to-local
	echo "\nDo not forget git push\n"
	
generate-intl: ## Generate localization file
	/Users/dle/Documents/Flutter/Software/new-flutter/bin/flutter pub run intl_utils:generate

generate-model: ## Generate Json serialization for model classes and GraphQL classes from graphql files
	/Users/dle/Documents/Flutter/Software/new-flutter/bin/flutter pub run build_runner build --delete-conflicting-outputs