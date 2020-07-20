import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { PoBreadcrumb, PoI18nService, PoBreadcrumbItem } from '@po-ui/ng-components';

import { IdiomaService } from './../resources/idioma.service';

@Component({
  selector: 'app-idioma-detail',
  templateUrl: './idioma-detail.component.html',
  styleUrls: ['./idioma-detail.component.css']
})

export class IdiomaDetailComponent implements OnInit {
  // definicao das variaveis utilizadas
  public currentId: string;
  public fields: Array<any> = [];
  public record = {};
  public showLoading = false;

  public literals;

  public breadcrumb: PoBreadcrumb = { items: [] };
  public breadcrumbItem: PoBreadcrumbItem;

  // construtor com os servicos necessarios
  constructor(
    private service: IdiomaService,
    private activatedRoute: ActivatedRoute,
    private route: Router,
    private poI18nService: PoI18nService
  ) {
    poI18nService.getLiterals().subscribe((literals) => {
      this.literals = literals;
    });
  }

  // load do componente
  public ngOnInit(): void {
    this.activatedRoute.params.subscribe(pars => {
      this.showLoading = true;

      // carrega o registro pelo ID
      this.currentId = pars['id'];
      this.service.getById(this.currentId).subscribe(resp => {
        Object.keys(resp).forEach((key) => this.record[key] = resp[key]);

        // carrega a lista de campos somente apos receber o registro a ser apresentado
        this.fields = this.service.getFieldList(false, this.literals);
        if (this.fields === null || this.fields.length === 0) {
          this.service.getMetadata().subscribe(data => {
            this.fields = data['items'];
            this.service.setFieldList(this.fields);
            this.showLoading = false;
          });
        }
        this.showLoading = false;
      });
    });

    this.setBreadcrumb();
  }

  private setBreadcrumb(): void {
    this.breadcrumbItem = { label: this.literals?.home, link: '/' };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
    this.breadcrumbItem = { label: this.literals?.language, link: '/idiomas' };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
    this.breadcrumbItem = { label: this.literals?.detail };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
  }

  // Redireciona quando clicar no botao Edit
  public editClick(): void {
    this.route.navigate(['/idiomas', 'edit', this.currentId]);
  }

  // Redireciona quando clicar no botao Voltar
  public goBackClick(): void {
    this.route.navigate(['/idiomas']);
  }
}
