import {
    storage,
    env,
    Context, 
    PersistentVector, 
    PersistentUnorderedMap
} from "near-sdk-as";

import { AccountId, Timestamp } from "./utils";

export const patients = new PersistentUnorderedMap<string, Patient>("patients");
export const doctors = new PersistentUnorderedMap<string, Doctor>("doctors");
export const reportList: PersistentVector<PatienReport> = new PersistentVector<PatienReport>('reports');


@nearBindgen
export class Patient {
    patentId: string;
    created_at: Timestamp = Context.blockTimestamp;
    author: AccountId = Context.predecessor;
    comment: string
    constructor(patentId: string, comment: string) {
        this.patentId = patentId;
        this.comment = comment;
    }

    static createPatient(patentId: string, comment: string): Patient {
        this.assert_patient(patentId);
        const patient = new Patient(patentId, comment);
        patients.set(patient.patentId, patient);
        return patient;
    }

    static getPatientById(patentId: string): Patient {
        return patients.getSome(patentId);
    }

    static getPatientList(): Patient[] {
        let limit = patients.length;
        let offset: u32 = 0;
        return patients.values(offset, offset + limit);
    }
    
    static deletePatient(patentId: string): void {
        patients.delete(patentId);
    }

    static assert_patient(patentId: string): void {
        assert(!patients.contains(patentId), "This patient exists. Please select another !!")
    }
}


@nearBindgen
export class Doctor {
    doctorId: string;
    qualification: string;
    constructor(id: string, qualification: string) {
        this.doctorId = id;
        this.qualification = qualification;
    }

    static createDoctor(id: string, qualification: string): Doctor {
        this.assert_doctor(id);
        let doctor = new Doctor(id, qualification);
        doctors.set(doctor.doctorId, doctor);
        return doctor;
    }

    static getDoctorById(doctorId: string): Doctor {
        return doctors.getSome(doctorId);
    }

    static getDoctorList(): Doctor[] {
        let limit = doctors.length;
        let offset: u32 = 0;
        return doctors.values(offset, offset + limit);
    }
    
    static deleteDoctor(doctorId: string): void {
        assert(!this.isDoctorInUse(doctorId), "This doctor cannot be deleted because it's entered in reports!")
        doctors.delete(doctorId);        
    }

    static assert_doctor(doctorId: string): void {
        assert(!doctors.contains(doctorId), "This doctor exists. Please select another !!")
    }

    // helper function
    static isDoctorInUse(doctorId: string): boolean {  
        for(let i = 0; i < reportList.length; ++i) {
      
          let patReport = reportList[i]
            if(patReport.doctorId == doctorId)
                return true;
        }
        return false;
    }
}


@nearBindgen
export class PatienReport {  
    reportID: u64 = Context.blockTimestamp;
    report: string = "";
    sender: string = "";
    doctorId: string = "";
    patienId: string = "";
    timestamp: u64 = 0;
    viewers: Set<string> = new Set<string>();

    constructor(report: string) {
        this.report = report;
        this.sender = Context.sender;
        this.timestamp = Context.blockTimestamp;
    }

    static create_patientReport(report: string, patientId: string, doctorId: string, viewers: string[]): u32 {    
        this.assert_patientReport(Context.sender);
        let patient = Patient.getPatientById(patientId);
        let doctor = Doctor.getDoctorById(doctorId);
        
        let patientReport = new PatienReport(report);
        patientReport.patienId = patientId;
        patientReport.doctorId = doctor.doctorId;

        for(let i = 0; i < viewers.length; ++i) {
          let viewer = viewers[i];
          assert(env.isValidAccountID(viewer), "viewer account is invalid");
          patientReport.viewers.add(viewer)
        }

        let index = reportList.push(patientReport);
        return index;
    }

    static getAllPatientReports(): PatienReport[] {
      
        const result = new Array<PatienReport>()
      
        for(let i = 0; i < reportList.length; ++i) {
            if(reportList[i].patienId == Context.sender)
                result.push(reportList[i]);
            else if(reportList[i].doctorId == Context.sender)
                result.push(reportList[i]);
        }
        return result;
    }

    static getPatientReportsByPatientId(patientId: string): PatienReport[] {
      
        const result = new Array<PatienReport>()
      
        for(let i = 0; i < reportList.length; ++i) {
      
            let patReport = reportList[i];
            if(patReport.patienId == patientId)
                result.push(patReport);
        }
        return result;
    }

    static getPatientReportsById(reportID: u64): PatienReport {  
        for(let i = 0; i < reportList.length; ++i) {
      
          let patReport = reportList[i]
            if(patReport.reportID == reportID)
                return patReport;
        }
        return new PatienReport("");
    }
    
    static deleteAllPatientReports(): void {
        while(reportList.length !==0)
            reportList.pop();
    }

    static assert_patientReport(doctorId: string): void {
        assert(!doctors.contains(doctorId), "Doctor could not found!!")
    }
}