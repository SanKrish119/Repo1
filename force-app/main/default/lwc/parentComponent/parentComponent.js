import { LightningElement,api,track } from 'lwc';

export default class ParentComponent extends LightningElement {
    
    @track selected;
    @api list = [
        {
            Id: 1,
            Name: 'Srihitha',
            Title: 'VP of Engineering',
        },
        {
            Id: 2,
            Name: 'Teja',
            Title: 'VP of Sales',
        },
        {
            Id: 3,
            Name: 'Ramya',
            Title: 'CEO',
        },
    ];

    handle(event){
        //alert('inside handler parent');
        const selec =event.detail;
        this.selected = this.list.find(loop => loop.Id === selec);
    }

}