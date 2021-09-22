import { LightningElement } from 'lwc';
import Contact_Language from '@salesforce/schema/Contact.Languages__c';
import Contact_name from '@salesforce/schema/Contact.Name';
export default class HelloWorld extends LightningElement {
  greeting = 'World';

  fields = [Contact_Language,Contact_name];

  changeHandler(event) {
    this.greeting = event.target.value;
  }

  handleSuccess(event) {
    const evt = new ShowToastEvent({
        title: "Account created",
        message: "Record ID: " + event.detail.id,
        variant: "success"
    });
    this.dispatchEvent(evt);
}
}