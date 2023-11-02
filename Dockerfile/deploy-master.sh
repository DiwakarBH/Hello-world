#!/bin/bash
#option=1
env=$1
#if [ $option == 1 ]
#then
#  echo "Pulling the repo and the submodules"
#  git config --global credential.helper 'cache --timeout=120'

dir=$(pwd)

if [ -z $env ];
then
  echo "please pass DC names like thermax, utcl, prod, qa, kube"
  echo "exiting"
  exit
fi

git pull --recurse-submodules
  cd src/layout/charts
  git checkout master
  git pull
  cd -

  cd src/layout/chatbox
  git checkout master
  git pull
  cd -

  cd src/layout/footer
  git checkout master
  git pull
  cd -

  cd src/layout/navbar
  git checkout master
  git pull
  cd -

  cd src/layout/tables
  git checkout master
  git pull
  cd -
#  git config --global --unset credential.helper
#fi

echo "------------------------ CLEAN ------------------------"
cp .env.$env .env
source .env

echo "$I_TAG $REACT_APP_LS_PREFIX-$APP_NAME"

sleep 10

echo "------------------------ INSTALL ------------------------"
# sudo rm -rf node_modules
sudo rm -rf build
sudo rm -rf static
sudo npm i --legacy-peer-deps
echo "------------------------ BUILD --------------------------"
sudo npm run build

echo "------------------------ DOCKER BUILD --------------------------"
docker build --no-cache -t $APP_NAME:$I_TAG .
docker tag $APP_NAME:$I_TAG dev.exactspace.co/$APP_NAME:$I_TAG
docker push dev.exactspace.co/$APP_NAME:$I_TAG
docker rmi $APP_NAME:$I_TAG


git clone git@github.com:exact-space/react-static-files-$REACT_APP_LS_PREFIX.git

# cd static

# for file in $(cat $REACT_APP_LS_PREFIX-$APP_NAME-css.txt)
# do
# cd css/ && rm $file && cd -
# done

# for file in $(cat $REACT_APP_LS_PREFIX-$APP_NAME-js.txt)
# do
# cd js/ && rm $file && cd -
# done
# cd $dir
cd build && cp -r static/* ../react-static-files-$REACT_APP_LS_PREFIX && cd -
git status
cd  react-static-files-$REACT_APP_LS_PREFIX && git add . && git commit -m "new static files" && git push origin main
cd $dir
rm -rf react-static-files-$REACT_APP_LS_PREFIX

#git add $REACT_APP_LS_PREFIX-$APP_NAME-media.txt $REACT_APP_LS_PREFIX-$APP_NAME-css.txt $REACT_APP_LS_PREFIX-$APP_NAME-js.txt && git commit -m "new static file listt" && git push origin master && cd -


#cd build && cp -r static/ /space/es-master/uploads/ && DIR=`date +%F-%H%M` && zip -r $DIR-login-$I_TAG-static.zip static &&  mv $DIR-login-$I_TAG-static.zip /space/es-master/uploads/ && cd -
# sudo rm -rf node_modules

