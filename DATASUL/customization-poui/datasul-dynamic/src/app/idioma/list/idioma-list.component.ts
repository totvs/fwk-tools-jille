import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { PoBreadcrumb, PoBreadcrumbItem, PoI18nService } from '@po-ui/ng-components';
import { PoPageDynamicTableActions } from '@po-ui/ng-templates';

import { IdiomaService } from './../resources/idioma.service';

@Component({
  selector: 'app-idioma-list',
  templateUrl: './idioma-list.component.html',
  styleUrls: ['./idioma-list.component.css']
})

export class IdiomaListComponent implements OnInit {
  // Definicao das variaveis utilizadas
  public serviceApi: string;
  public fields: Array<any> = [];
  public showLoading = false;

  public literals;

  public readonly actions: PoPageDynamicTableActions = {
    new: '/idiomas/create',
    detail: '/idiomas/detail/:id',
    edit: '/idiomas/edit/:id',
    remove: true,
    removeAll: true
  };

  public breadcrumb: PoBreadcrumb = { items: [] };
  public breadcrumbItem: PoBreadcrumbItem;

  // Construtor da classe
  constructor(
    private service: IdiomaService,
    private route: Router,
    private poI18nService: PoI18nService
    ) {
      // this.poI18nService.setLanguage('pt-BR');
      this.poI18nService.setLanguage('en-US');

      poI18nService.getLiterals().subscribe((literals) => {
        this.literals = literals;
      });
    }

  // Load do componente
  public ngOnInit(): void {
    this.fields = [];
    this.serviceApi = this.service.getUrl();
    this.showLoading = true;

    this.service.getMetadata().subscribe(resp => {
      this.service.setFieldList(resp['items']);
      this.fields = this.service.getFieldList(false, this.literals);
      this.showLoading = false;
    });

    this.setBreadcrumb();
  }

  private setBreadcrumb(): void {
    this.breadcrumbItem = { label: this.literals?.home, link: '/' };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
    this.breadcrumbItem = { label: this.literals?.language, link: undefined };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
  }
}
