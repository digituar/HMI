#!/usr/bin/env bash

# exit on first error after this point to avoid redeploying with successful build
set -e

echo
echo ---------------------------------------------------------
echo "Step 0: Check for environment variable with contract name"
echo ---------------------------------------------------------
echo

[ -z "$CONTRACT" ] && echo "Missing \$CONTRACT environment variable" && exit 1
[ -z "$CONTRACT" ] || echo "Found it! \$CONTRACT is set to [ $CONTRACT ]"

echo
echo
echo ---------------------------------------------------------
echo "Step 1: Call 'view' functions on the contract"
echo
echo "(run this script again to see changes made by this file)"
echo ---------------------------------------------------------
echo

near view $CONTRACT getPatientList '{}' --accountId YOUR-NAME.testnet

echo
echo

near view $CONTRACT getPatientById '{"patentId": "digituar.testnet"}' --accountId YOUR-NAME.testnet

echo
echo

near view $CONTRACT getDoctorList '{}' --accountId YOUR-NAME.testnet

echo
echo

near view $CONTRACT getDoctorById '{"doctorId": "digituar.testnet"}' --accountId YOUR-NAME.testnet

echo
echo
echo ---------------------------------------------------------
echo "Step 2: Call 'change' functions on the contract"
echo ---------------------------------------------------------
echo

near call $CONTRACT createPatient '{"patentId": "digituar.testnet", "comment": "admin"}' --accountId YOUR-NAME.testnet

echo
echo

near call $CONTRACT createDoctor '{"id": "doc1.testnet", "qualification": "DDerm - Diploma in Dermatology"}' --accountId YOUR-NAME.testnet
near call $CONTRACT createDoctor '{"id": "doc2.testnet", "qualification": "Orthopedist"}' --accountId YOUR-NAME.testnet

echo
echo

near call $CONTRACT create_patientReport '{"report": "The clinical impression was that he was manifesting behavioural etc...", "patientId": "digituar.testnet", "doctorId": "doc1.testnet", "viewers": ["doc1.testnet"]}' --accountId YOUR-NAME.testnet
near call $CONTRACT create_patientReport '{"report": "TEST REPORT 2 ...", "patientId": "digituar.testnet", "doctorId": "doc2.testnet", "viewers": ["doc2.testnet"]}' --accountId digituar.testnet
near call $CONTRACT create_patientReport '{"report": "TEST REPORT 3 ...", "patientId": "digituar.testnet", "doctorId": "doc1.testnet", "viewers": ["doc1.testnet"]}' --accountId digituar.testnet
echo
echo

near call $CONTRACT getAllPatientReports '{}' --accountId YOUR-NAME.testnet

echo
echo

near call $CONTRACT getPatientReportsByPatientId '{"patentId": "digituar.testnet"}' --accountId YOUR-NAME.testnet

echo
echo

near call $CONTRACT getPatientReportsById '{"reportID": "[ $report id from getPatientReportsByPatientId method ]"}' --accountId YOUR-NAME.testnet

echo
echo

near call $CONTRACT deleteAllPatientReports '{}' --accountId YOUR-NAME.testnet

echo
echo

near call $CONTRACT deletePatient '{"patentId": "digituar.testnet"}' --accountId YOUR-NAME.testnet

echo
echo

near call $CONTRACT deleteDoctor '{"doctorId": "doc1.testnet"}' --accountId YOUR-NAME.testnet

echo
echo "now run this script again to see changes made by this file"
exit 0
