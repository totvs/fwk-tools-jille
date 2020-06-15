import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { PoBreadcrumb } from '@po-ui/ng-components';
import { PoPageDynamicTableActions } from '@po-ui/ng-templates';

import { IdiomaService } from './../resources/idioma.service';

@Component({
  selector: 'app-idioma-list',
  templateUrl: './idioma-list.component.html',
  styleUrls: ['./idioma-list.component.css']
})

export class IdiomaListComponent implements OnInit {
  // Definicao das variaveis utilizadas
  public cTitle = 'Manutenção de Idiomas';
  public serviceApi: string;
  public fields: Array<any> = [];
  public showLoading = false;

  public readonly actions: PoPageDynamicTableActions = {
    new: '/idiomas/create',
    detail: '/idiomas/detail/:id',
    edit: '/idiomas/edit/:id',
    remove: true,
    removeAll: true
  };

  public readonly breadcrumb: PoBreadcrumb = {
    items: [
      { label: 'Home', link: '/' },
      { label: 'Idiomas'}
    ]
  };

  // Construtor da classe
  constructor(
    private service: IdiomaService,
    private route: Router
  ) { }

  // Load do componente
  public ngOnInit(): void {
    this.fields = [];
    this.serviceApi = this.service.getUrl();
    this.showLoading = true;
    this.service.getMetadata().subscribe(resp => {
      this.fields = resp['items'];
      this.service.setFieldList(this.fields);
      this.showLoading = false;
    });
  }
}
