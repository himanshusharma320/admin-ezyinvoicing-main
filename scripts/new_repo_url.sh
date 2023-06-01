#!/bin/bash

SYNC_APP=~/frappe-bench/apps/invoice_sync
FRONTEND=~/ezy-invoice-production
BACKEND=~/frappe-bench/apps/version2_app
PARSER=~/frappe-bench/apps/version2_app/version2_app/parsers_invoice/invoice_parsers

##### Adding safe.directory
#sudo git config --system --add safe.directory /home/frappe/frappe-bench/apps/invoice_sync
#sudo git config --system --add safe.directory /home/frappe/frappe-bench/apps/version2_app
#sudo git config --system --add safe.directory /home/frappe/frappe-bench/apps/version2_app/version2_app/parsers_invoice/invoice_parsers

# Adding new repo url for frontend

cd $FRONTEND || exit
    echo "current path:$PWD"
        sudo git config --system --add safe.directory $FRONTEND
    echo "Added 'frontend' safe.directory"
# command to remove old repo url's
        git remote remove origin
    echo "Old origin removed"
        git remote remove upstream
    echo "Old repo url's are removed"
        sleep 1
        git remote add origin http://gitlab-ci-token:glpat-6jFz6cnTHdHyDpuPVujy@gitlab.caratred.com/pavansai1122/ezy-invoice-production.git
    echo "New origin repo url added successfully for 'FRONTEND'"
        git remote add upstream http://gitlab-ci-token:glpat-6jFz6cnTHdHyDpuPVujy@gitlab.caratred.com/pavansai1122/ezy-invoice-production.git
    echo "New upstream repo url added successfully for 'FRONTEND'"

# Adding new repo url for backend
cd $BACKEND  || exit
    echo "current path:$PWD"
        sudo git config --system --add safe.directory $BACKEND
    echo "Added 'backend' safe.directory"
# command to remove old repo url's
        git remote remove origin
    echo "Old origin repo url removed"
        git remote remove upstream
    echo "Old upstream repo url's removed"
        sleep 1
        git remote add origin https://gitlab-ci-token:glpat-yk-_nkFvkGysxbYUevnz@gitlab.caratred.com/ganesh.s/EzyinvoiceDemo.git
    echo "New origin repo url added successfully for 'BACKEND'"
        git remote add upstream https://gitlab-ci-token:glpat-yk-_nkFvkGysxbYUevnz@gitlab.caratred.com/ganesh.s/EzyinvoiceDemo.git
    echo "New upstream repo url added successfully for 'BACKEND'"

# Adding new repo url for parser
cd $PARSER || exit
    echo "current path:$PWD"
        sudo git config --system --add safe.directory $PARSER
    echo "Added 'parser' safe.directory"
# command to remove old repo url's
        git remote remove origin
    echo "Old origin repo url removed"
        git remote remove upstream
    echo "Old upstream repo url's removed"
        sleep 1
        git remote add origin https://GIT_CI_TOKEN:glpat-_DiMvF-rreUMypxhSGqm@gitlab.caratred.com/prasanthvajja/invoice_parsers.git
    echo "New origin repo url added successfully for 'PARSER'"
        #git remote add upstream https://GIT_CI_TOKEN:glpat-_DiMvF-rreUMypxhSGqm@gitlab.caratred.com/prasanthvajja/invoice_parsers.git

# Adding new repo url for invoice-sync
if [ -n "$SYNC_APP" ]; then
	cd $SYNC_APP || exit
	    sudo git config --system --add safe.directory $SYNC_APP
	echo "Added 'invoice-sync' safe.directory"
	    git remote remove origin
    echo "Old origin url removed"
	    git remote remove upstream
	echo "Old upstream url removed"
	    git remote add origin https://gitlab-ci-token:glpat-ABxg_B5Uqsy6yTLkqWpw@gitlab.caratred.com/sumanth512/invoice-sync.git
    echo "New origin repo url added successfully for 'SYNC_APP'"
        git remote add upstream https://gitlab-ci-token:glpat-ABxg_B5Uqsy6yTLkqWpw@gitlab.caratred.com/sumanth512/invoice-sync.git
    echo "New UPSTREAM repo url added successfully for 'SYNC_APP'"    
else
	echo "SYNC_APP is not available"
fi
