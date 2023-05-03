import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import punchIn from '@salesforce/apex/HandleAttandenceController.doPunchIn';
import punchOut from '@salesforce/apex/HandleAttandenceController.doPunchOut';
import halfDay from '@salesforce/apex/HandleAttandenceController.halfDay';
import checkCurrentStatus from '@salesforce/apex/HandleAttandenceController.checkCurrentStatus';
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class AttendanceComponent extends LightningElement {
 
    @track disablePunchIn = true;
    @track disablePunchOut = true;
    @track disableHalfDay = true;

    get isDesktop() {
        return FORM_FACTOR === 'Large';
    }

    @wire(checkCurrentStatus)
    record({data, error}){
        console.log('data'+JSON.stringify(data));
        if(data){

            if(data == 'punchout'){
                this.disablePunchOut = false;
            }

            else if(data == 'halfDay'){
                this.disableHalfDay = false;
            }

            else if(data == 'both'){
                this.disablePunchIn = false;
                this.disableHalfDay = false;
            }
            else if(data == 'None'){
                this.disablePunchIn = true;
                this.disablePunchOut = true;
                this.disableHalfDay = true;
            }
        }
        else if(error){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Attendance has not been Punched!! Error Occured : ' + error,
                    variant: 'danger'
                })
            );
        }
    }

    handleOnClickPunchIn(){
        punchIn()
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Attendance have been punched Successfully!!',
                    variant: 'success'
                })
            );
            location.reload();
        })
        .catch(error =>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Attendance has not been Punched!! Error Occured : ' + error,
                    variant: 'danger'
                })
            );
        });
    }

    handleOnClickHalfday(){
        halfDay()
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Half day Punched Successfully!!',
                    variant: 'success'
                })
            );
            location.reload();
        })
        .catch(error =>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Attendance has not been Punched!! Error Occured : ' + error,
                    variant: 'danger'
                })
            );
        });
    }

    handleOnClickPunchOut(){
        punchOut()
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Punched Out Successfully!!',
                    variant: 'success'
                })
            );
            location.reload();
        })
        .catch(error =>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Attendance has not been Punched!! Error Occured : ' + error,
                    variant: 'danger'
                })
            );
        });
    }   
}