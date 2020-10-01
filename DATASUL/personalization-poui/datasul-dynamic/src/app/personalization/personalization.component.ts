import { Component, OnInit } from '@angular/core';
import { PoBreadcrumb, PoBreadcrumbItem, PoNotificationService } from '@po-ui/ng-components';

import { PersonalizationService } from './personalization.service';

@Component({
  selector: 'app-personalization',
  templateUrl: './personalization.component.html',
  styleUrls: ['./personalization.component.css']
})

export class PersonalizationComponent implements OnInit {
  // definicao das variaveis utilizadas
  public currentId: string;
  public fields: Array<any> = [];
  public record = {};
  public showLoading = false;
  public cProg = 'pedido-execucao-monitor';

  public breadcrumb: PoBreadcrumb = { items: [] };
  public breadcrumbItem: PoBreadcrumbItem;

  // construtor com os servicos necessarios
  constructor(
    private service: PersonalizationService,
    private poNotification: PoNotificationService
  ) { }

  // load do componente
  public ngOnInit(): void {
    this.showLoading = true;
    this.record = {};
    // busca os valores dos dados a serem apresentados
    this.service.loadValues(this.cProg, 'esp').subscribe(resp => {
      console.log(resp);
      Object.keys(resp).forEach((key) => this.record[key] = resp[key]);
      // carrega a lista de campos somente apos receber o registro a ser apresentado
      if (this.fields === null || this.fields.length === 0) {
        this.service.loadMetadata(this.cProg).subscribe(metadata => {
          // tslint:disable-next-line:no-string-literal
          this.fields = metadata['fields'];
          this.showLoading = false;
        });
      }
    });

    this.setBreadcrumb();
  }

  private setBreadcrumb(): void {
    this.breadcrumbItem = { label: 'Home', link: '/' };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
    this.breadcrumbItem = { label: 'Personalização' };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
  }

  // Redireciona quando clicar no botao Edit
  public editClick(): void {
    this.poNotification.information('Voce clicou na edição dos dados');
  }

  // Redireciona quando clicar no botao Voltar
  public goBackClick(): void {
    this.poNotification.information('Voce clicou para retornar para a tela anterior');
  }
}
