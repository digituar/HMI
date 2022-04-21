/*
 *
 * Learn more about writing NEAR smart contracts with AssemblyScript:
 * https://docs.near.org/docs/roles/developer/contracts/assemblyscript
 *
 */

import { PatienReport, Patient, Doctor } from './model';

/* Patient Functions*/

export function createPatient(patentId: string, comment: string): Patient[] {
    Patient.createPatient(patentId, comment);
    return Patient.getPatientList();
}

export function getPatientById(patentId: string): Patient {
    return Patient.getPatientById(patentId);
}

export function getPatientList():Patient[] {
    return Patient.getPatientList();
}


export function deletePatient(patentId: string): void {
    Patient.deletePatient(patentId);
}


/* Doctor Functions*/

export function createDoctor(id: string, qualification: string): Doctor[] {
    Doctor.createDoctor(id, qualification);
    return Doctor.getDoctorList();
}

export function getDoctorById(doctorId: string): Doctor {
    return Doctor.getDoctorById(doctorId);
}


export function deleteDoctor(doctorId: string): void {
    Doctor.deleteDoctor(doctorId);
}


export function getDoctorList(): Doctor[] {
    return Doctor.getDoctorList();
}


/* PatientReport Functions */

export function create_patientReport(report: string, patientId: string, doctorId: string, viewers: string[]) : u32 {
    let index = PatienReport.create_patientReport(report, patientId, doctorId, viewers);    
    return index;
}

export function getAllPatientReports(): PatienReport[] {
    return PatienReport.getAllPatientReports();
}

export function getPatientReportsByPatientId(patentId: string): PatienReport[] {
    return PatienReport.getPatientReportsByPatientId(patentId);
}

export function getPatientReportsById(reportID: u64): PatienReport {
    return PatienReport.getPatientReportsById(reportID);
}

export function deleteAllPatientReports(): void {
    PatienReport.deleteAllPatientReports();
}