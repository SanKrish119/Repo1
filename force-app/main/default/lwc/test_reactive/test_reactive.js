import { LightningElement, wire, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
export default class Test_reactive extends LightningElement {
@api recordId;
ratingHot;
ratingWarm;
ratingCold;
    @wire(getRecord,{recordId : '$recordId', fields : ['Account.Name','Account.Rating']})
    wiredAccount({data,error}){
        if(data){
            console.log(data.fields.Rating.value);
            switch(data.fields.Rating.value){
                case "Hot":
                    console.log('hot');
                    this.ratingHot = true;
                    this.ratingWarm =false;
                    this.ratingCold = false;
                    break;
                case "Warm":
                    this.ratingHot = false;
                    this.ratingWarm =true;
                    this.ratingCold = false;
                    break;
                case "Cold":
                    this.ratingHot = false;
                    this.ratingWarm =false;
                    this.ratingCold = true;
                    break;
            }
        }else if(error){
            console.log(error);
        }
    }
}