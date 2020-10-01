import { Component } from '@angular/core';
import { PoMenuItem } from '@po-ui/ng-components';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  styles: []
})
export class AppComponent {
  title = 'app';

  public menus: PoMenuItem[] = [
    {
      label: 'Personalização', link: '/personalization'
    }
  ];
}
