import { Component, OnInit } from '@angular/core';
import { PoBreadcrumb, PoBreadcrumbItem } from '@po-ui/ng-components';
import { PoPageDynamicTableActions } from '@po-ui/ng-templates';

import { PersonalizationService } from './../personalization.service';

@Component({
  selector: 'app-personalization-list',
  templateUrl: './personalization-list.component.html',
  styleUrls: ['./personalization-list.component.css']
})
export class PersonalizationListComponent implements OnInit {
  // Definicao das variaveis utilizadas
  public serviceApi: string;
  public fields: Array<any> = [];
  public showLoading = false;

  public literals;

  public readonly actions: PoPageDynamicTableActions = {
    new: '/personalization/create',
    detail: '/personalization/detail/:id',
    edit: '/personalization/edit/:id',
    remove: true
  };

  public breadcrumb: PoBreadcrumb = { items: [] };
  public breadcrumbItem: PoBreadcrumbItem;

  // Construtor da classe
  constructor(
    private service: PersonalizationService
    ) { }

  // Load do componente
  public ngOnInit(): void {
    this.fields = [];
    this.serviceApi = this.service.getUrlArea();
    this.showLoading = true;

    this.service.loadMetadata().subscribe(metadata => {
      // tslint:disable-next-line:no-string-literal
      this.fields = metadata['fields'];
      this.showLoading = false;
    });

    this.setBreadcrumb();
  }

  private setBreadcrumb(): void {
    this.breadcrumbItem = { label: 'Home', link: '/' };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
    this.breadcrumbItem = { label: 'Listagem de Idiomas' };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
  }
}
