#!/usr/bin/env bash

# exit on first error after this point to avoid redeploying with successful build
set -e

echo
echo ---------------------------------------------------------
echo "Step 0: Check for environment variable with contract name"
echo ---------------------------------------------------------
echo

[ -z "$CONTRACT" ] && echo "Missing \$CONTRACT environment variable" && exit 1
[ -z "$OWNER" ] && echo "Missing \$OWNER environment variable" && exit 1
[ -z "$CONTRACT" ] || echo "Found it! \$CONTRACT is set to [ $CONTRACT ]"
[ -z "$OWNER" ] || echo "Found it! \$CONTRACT is set to [ $OWNER ]"

echo
echo
echo ---------------------------------------------------------
echo "Step 1: Call 'create' functions on the contract"
echo ---------------------------------------------------------
echo

near call $CONTRACT createPatient '{"patentId": "digituar.testnet", "comment": "admin"}' --accountId $OWNER

echo
echo

near call $CONTRACT createDoctor '{"id": "doc1.testnet", "qualification": "DDerm - Diploma in Dermatology"}' --accountId $OWNER
near call $CONTRACT createDoctor '{"id": "doc2.testnet", "qualification": "Orthopedist"}' --accountId $OWNER

echo
echo

near call $CONTRACT create_patientReport '{"report": "The clinical impression was that he was manifesting behavioural etc...", "patientId": "digituar.testnet", "doctorId": "doc1.testnet", "viewers": ["doc1.testnet"]}' --accountId $OWNER
near call $CONTRACT create_patientReport '{"report": "TEST REPORT 2 ...", "patientId": "digituar.testnet", "doctorId": "doc2.testnet", "viewers": ["doc2.testnet"]}' --accountId $OWNER
near call $CONTRACT create_patientReport '{"report": "TEST REPORT 3 ...", "patientId": "digituar.testnet", "doctorId": "doc1.testnet", "viewers": ["doc1.testnet"]}' --accountId $OWNER



echo
echo
echo ---------------------------------------------------------
echo "Step 12: Call 'view' functions on the contract"
echo ---------------------------------------------------------
echo

near view $CONTRACT getPatientList '{}' --accountId $OWNER

echo
echo

near view $CONTRACT getPatientById '{"patentId": "digituar.testnet"}' --accountId $OWNER

echo
echo

near view $CONTRACT getDoctorList '{}' --accountId $OWNER

echo
echo

near view $CONTRACT getDoctorById '{"doctorId": "doc1.testnet"}' --accountId $OWNER

echo
echo


near call $CONTRACT getAllPatientReports '{}' --accountId $OWNER

echo
echo

near call $CONTRACT getPatientReportsByPatientId '{"patentId": "digituar.testnet"}' --accountId $OWNER

echo
echo

near call $CONTRACT getPatientReportsById '{"reportID": "[ $report id from getPatientReportsByPatientId method ]"}' --accountId $OWNER


echo
echo
echo ---------------------------------------------------------
echo "Step 3: Call 'delete' functions on the contract"
echo ---------------------------------------------------------
echo

near call $CONTRACT deleteAllPatientReports '{}' --accountId $OWNER

echo
echo

near call $CONTRACT deletePatient '{"patentId": "digituar.testnet"}' --accountId $OWNER

echo
echo

near call $CONTRACT deleteDoctor '{"doctorId": "doc1.testnet"}' --accountId $OWNER

echo
exit 0
