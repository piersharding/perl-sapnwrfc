#!/bin/sh
BASE=/home/piers/git/public/perl-sapnwrfc
cd $BASE
find . -name '*.log' -type f -exec echo \> {} \;
find . -name 'rfc*trc' -type f -exec rm -f {} \;
find . -name '*~' -type f -exec rm -f {} \;

VERS=0.33
DIST=sapnwrfc-$VERS
BALL=$DIST.tar.gz
ZIP=$DIST.zip

./build.sh

if [ -d $DIST ]; then
  echo "removing: $DIST ..."
  rm -rf $DIST
fi

if [ -f $BALL ]; then
  echo "removing: $BALL ..."
  rm -f $BALL
fi

if [ -f $ZIP ]; then
  echo "removing: $ZIP ..."
  rm -f $ZIP
fi

echo "make tar ball: $BALL"
make dist
ls -l $BALL
tar -xzvf $BALL

echo "make zip: $ZIP"
zip -r $ZIP $DIST
ls -l $ZIP

if [ -d $DIST ]; then
  echo "removing: $DIST ..."
  rm -rf $DIST
fi
echo "Done."

chmod -R a+r $BALL $ZIP

echo "Copy up distribution"
scp $BALL piersharding.com:www/download/
scp $ZIP piersharding.com:www/download/
