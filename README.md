# HMI - Health Medical Information

The HMI project is a demo of near smart contract with assemblyscript. It shows a simple example of how to exchange medical reports with other healthcare providers.

## Installation

```bash
git clone https://github.com/digituar/HMI
cd HMI
run `yarn install` (or `npm install`)
run `yarn`
```

### Commands

**Compile source to WebAssembly**

```sh
yarn build                    # asb --target debug
yarn build:release            # asb
```

## Deploy Smart Contract

First, you need to login

```
near login
```

Deploy to dev account (testnet only)

```sh
npm run build:release
near dev-deploy ./build/release/hmi.wasm
export CONTRACT=<dev-###-###>
```

Deploy to any account

```sh
npm run build:release
near deploy --accountId YOUR-NAME.testnet --wasmFile ./build/release/hmi.wasm
export CONTRACT=YOUR-NAME.testnet
```

## Access Smart Contract

<em>The <strong><u>doc1.testnet and doc2.testnet</u></strong> is a account that needs to be replaced with another accountId or sub accountId</em>.

<h3><u>Patient</u></h3>

Create new patient

```sh
near call $CONTRACT createPatient '{"patentId": "digituar.testnet", "comment": "admin"}' --accountId YOUR-NAME.testnet
```

List all patients

```sh
near view $CONTRACT getPatientList '{}' --accountId YOUR-NAME.testnet
```

Get patient details by id

```sh
near view $CONTRACT getPatientById '{"patentId": "digituar.testnet"}' --accountId YOUR-NAME.testnet
```

Delete patient

```sh
near call $CONTRACT deletePatient '{"patentId": "digituar.testnet"}' --accountId YOUR-NAME.testnet
```

<h3><u>Doctor</u></h3>

List all doctors

```sh
near view $CONTRACT getDoctorList '{}' --accountId YOUR-NAME.testnet
```

Create new doctor

```sh
near call $CONTRACT createDoctor '{"id": "doc1.testnet", "qualification": "DDerm - Diploma in Dermatology"}' --accountId YOUR-NAME.testnet
near call $CONTRACT createDoctor '{"id": "doc2.testnet", "qualification": "Orthopedist"}' --accountId YOUR-NAME.testnet
```

Get doctor details by id

```sh
near view $CONTRACT getDoctorById '{"doctorId": "digituar.testnet"}' --accountId YOUR-NAME.testnet
```

Delete doctor

```sh
near call $CONTRACT deleteDoctor '{"doctorId": "doc1.testnet"}' --accountId YOUR-NAME.testnet
```

<h3><u>Patient report</u></h3>

Create new patient report

```sh
 near call $CONTRACT create_patientReport '{"report": "The clinical impression was that he was manifesting behavioural etc...", "patientId": "digituar.testnet", "doctorId": "doc1.testnet", "viewers": ["doc1.testnet"]}' --accountId YOUR-NAME.testnet
```

List all patient reports

```sh
near call $CONTRACT getAllPatientReports '{}' --accountId YOUR-NAME.testnet
```

Get patient report details by patient id

```sh
near call $CONTRACT getPatientReportsByPatientId '{"patentId": "digituar.testnet"}' --accountId YOUR-NAME.testnet
```

Get patient report details by report id

```sh
near call $CONTRACT getPatientReportsById '{"reportID": "1650473673245405397"}' --accountId YOUR-NAME.testnet
```

Delete all patient reports

```sh
near call $CONTRACT deleteAllPatientReports '{}' --accountId YOUR-NAME.testnet
```
