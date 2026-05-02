wp_studio_repo_path="$HDCODE/_open/wordpress/studio"

git clone https://github.com/Automattic/studio.git "$wp_studio_repo_path"

cd $wp_studio_repo_path

nvm install

nvm use && npm install

npm audit fix

npm run package

chmod +x out/Studio-linux-x64/studio

./out/Studio-linux-x64/studio

