import { LightningElement,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
export default class HelloAndForm extends LightningElement {
    
    @track greeting = 'World';
    fields = [NAME_FIELD, REVENUE_FIELD, INDUSTRY_FIELD];

    handlechange(event){
        this.greeting = event.detail.value;
    }

    handleSuccess(event) {
        console.log('Logging event: '+JSON.stringify(event));
        const evt = new ShowToastEvent({
            title: "Account created",
            message: "Record ID: " + event.detail.id,
            variant: "success"
        });
        this.dispatchEvent(evt);
    }
    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        fields.AnnualRevenue = 0; // modify a field
        this.template.querySelector('[data-id="my Form"]').submit(fields);
     }

}