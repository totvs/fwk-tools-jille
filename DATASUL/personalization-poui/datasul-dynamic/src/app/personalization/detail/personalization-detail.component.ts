import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { PoBreadcrumb, PoBreadcrumbItem } from '@po-ui/ng-components';

import { PersonalizationService } from '../personalization.service';

@Component({
  selector: 'app-personalization-detail',
  templateUrl: './personalization-detail.component.html',
  styleUrls: ['./personalization-detail.component.css']
})

export class PersonalizationDetailComponent implements OnInit {
  public static cProg = 'html.aplicativos-eai';

  // definicao das variaveis utilizadas
  public currentId: string;
  public fields: Array<any> = [];
  public record = {};
  public showLoading = false;

  public breadcrumb: PoBreadcrumb = { items: [] };
  public breadcrumbItem: PoBreadcrumbItem;

  // construtor com os servicos necessarios
  constructor(
    private service: PersonalizationService,
    private activatedRoute: ActivatedRoute,
    private route: Router
  ) { }

  // load do componente
  public ngOnInit(): void {
    this.activatedRoute.params.subscribe(pars => {
      this.showLoading = true;
      this.record = {};

      // Carrega o registro pelo ID
      // tslint:disable-next-line:no-string-literal
      this.currentId = pars['id'];

      // busca os valores dos dados a serem apresentados
      this.service.loadValuesById(this.currentId).subscribe(resp => {
        Object.keys(resp).forEach((key) => this.record[key] = resp[key]);

        // carrega a lista de campos somente apos receber os dados a serem apresentados
        this.service.loadMetadata().subscribe(metadata => {
          // tslint:disable-next-line:no-string-literal
          this.fields = metadata['fields'];
          this.showLoading = false;
        });
      });
    });

    this.setBreadcrumb();
  }

  private setBreadcrumb(): void {
    this.breadcrumbItem = { label: 'Home', link: '/' };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
    this.breadcrumbItem = { label: 'Listagem de Idiomas' , link: '/personalization' };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
    this.breadcrumbItem = { label: 'Detalhe do Idioma' };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
  }

  // Redireciona quando clicar no botao Edit
  public editClick(): void {
    this.route.navigate(['/personalization', 'edit', this.currentId]);
  }

  // Redireciona quando clicar no botao Voltar
  public goBackClick(): void {
    this.route.navigate(['/personalization']);
  }
}
