import { Component, OnInit, ViewChild } from '@angular/core';
import { NgForm } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { PoBreadcrumb, PoBreadcrumbItem, PoDialogService, PoNotificationService } from '@po-ui/ng-components';

import { PersonalizationService } from './../personalization.service';

@Component({
  selector: 'app-personalization-edit',
  templateUrl: './personalization-edit.component.html',
  styleUrls: ['./personalization-edit.component.css']
})
export class PersonalizationEditComponent implements OnInit {
  // Define as variaveis a serem utilizadas
  public cTitle: string;
  public currentId: string;
  public record = {};
  public fields: Array<any> = [];
  public isUpdate = false;
  public showLoading = false;
  public validationUrl = this.service.getUrlAreaValidation();

  public breadcrumb: PoBreadcrumb = { items: [] };
  public breadcrumbItem: PoBreadcrumbItem;

   // Obtem a referencia do componente HTML
  @ViewChild('formEdit', { static: true })
  formEdit: NgForm;

  // Construtor da classe com os servicos necessarios
  constructor(
    private service: PersonalizationService,
    private activatedRoute: ActivatedRoute,
    private route: Router,
    private poDialog: PoDialogService,
    private poNotification: PoNotificationService
  ) { }

  // Load do componente
  public ngOnInit(): void {
    this.isUpdate = false;
    this.showLoading = true;

    // Carrega o registro pelo ID
    this.activatedRoute.params.subscribe(pars => {
      // tslint:disable-next-line:no-string-literal
      this.currentId = pars['id'];

      // Se nao tiver o ID definido sera um CREATE
      if (this.currentId === undefined) {
        this.isUpdate = false;
        this.cTitle = 'Novo Idioma';
      } else {
        this.isUpdate = true;
        this.cTitle = 'Edição do Idioma';
      }

      // Atualiza o breadcrumb de acordo com o tipo de edicao
      this.setBreadcrumb();

      // Se for uma alteracao, busca o registro a ser alterado
      if (this.isUpdate) {
        this.service.loadValuesById(this.currentId).subscribe(resp => {
          Object.keys(resp).forEach((key) => this.record[key] = resp[key]);

          // Em alteracao temos que receber o registro para depois buscar a lista de campos
          this.getMetadata();
        });
      } else {
        // Se for create, pega a lista de campos
        this.getMetadata();
      }
    });
  }

  private setBreadcrumb(): void {
    this.breadcrumbItem = { label: 'Home', action: this.beforeRedirect.bind(this) };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
    this.breadcrumbItem = { label: 'Listagem de Idiomas', action: this.beforeRedirect.bind(this) };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
    this.breadcrumbItem = { label: this.cTitle };
    this.breadcrumb.items = this.breadcrumb.items.concat(this.breadcrumbItem);
  }

  // Retorna a lista de campos
  private getMetadata() {
    this.service.loadMetadata().subscribe(metadata => {
        // tslint:disable-next-line:no-string-literal
        this.fields = metadata['fields'];
        this.showLoading = false;
    });
 }

  // Redireciona via breadcrumb
  private beforeRedirect(itemBreadcrumbLabel) {
    if (this.formEdit.valid) {
      this.route.navigate(['/']);
    } else {
      this.poDialog.confirm({
        title: 'Cancelamento de edição',
        message: 'Os dados ainda não foram gravados, confirma redirecinamento ?',
        confirm: () => this.route.navigate(['/'])
      });
    }
  }

  // Grava o registro quando clicado no botao Salvar
  public saveClick(): void {
    this.showLoading = true;
    if (this.isUpdate) {
      // Altera um registro ja existente
      this.service.update(this.currentId, this.record).subscribe(resp => {
        this.poNotification.success('Dados atualizados com sucesso');
        this.showLoading = false;
        this.route.navigate(['/personalization']);
      });
    } else {
      // Cria um registro novo
      this.service.create(this.currentId, this.record).subscribe(resp => {
        this.poNotification.success('Dados criados com sucesso');
        this.showLoading = false;
        this.route.navigate(['/personalization']);
      });
    }
  }

  // Cancela a edicao e redireciona ao clicar no botao Cancelar
  public cancelClick(): void {
    this.poDialog.confirm({
      title: 'Confirmar cancelamento',
      message: 'Voce deseja realmente cancelar a edição?',
      confirm: () => this.route.navigate(['/personalization'])
    });
  }
}
