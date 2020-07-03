import { Component, OnInit, ViewChild } from '@angular/core';
import { NgForm } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { PoBreadcrumb, PoDialogService, PoNotificationService } from '@po-ui/ng-components';

import { IdiomaService } from './../resources/idioma.service';

@Component({
  selector: 'app-idioma-edit',
  templateUrl: './idioma-edit.component.html',
  styleUrls: ['./idioma-edit.component.css']
})

export class IdiomaEditComponent implements OnInit {
  // Define as variaveis a serem utilizadas
  public cTitle: string;
  public currentId: string;
  public record = {};
  public fields: Array<any> = [];
  public isUpdate = false;
  public showLoading = false;

  public breadcrumb: PoBreadcrumb;

  // Obtem a referencia do componente HTML
  @ViewChild('formEdit', { static: true })
  formEdit: NgForm;

  // Construtor da classe com os servicos necessarios
  constructor(
    private service: IdiomaService,
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
        this.cTitle = 'Inclusão de Idioma';
      } else {
        this.isUpdate = true;
        this.cTitle = 'Alteração de Idioma';
      }

      // Atualiza o breadcrumb de acordo com o tipo de edicao
      this.breadcrumb = {
        items: [
          { label: 'Home', action: this.beforeRedirect.bind(this) },
          { label: 'Idiomas', action: this.beforeRedirect.bind(this) },
          { label: this.cTitle }
        ]
      };

      // Se for uma alteracao, busca o registro a ser alterado
      if (this.isUpdate) {
        this.service.getById(this.currentId).subscribe(resp => {
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

  // Retorna a lista de campos
  private getMetadata() {
    let fieldList: Array<any> = [];

    // Carrega a lista de campos, trabalhando com um cache da lista de campos
    fieldList = this.service.getFieldList(this.isUpdate);
    if (fieldList === null || fieldList.length === 0) {
      this.service.getMetadata().subscribe(resp => {
        // tslint:disable-next-line:no-string-literal
        this.service.setFieldList(resp['items']);
        this.fields = this.service.getFieldList(this.isUpdate);
        this.showLoading = false;
      });
    } else {
      this.fields = fieldList;
      this.showLoading = false;
    }
  }

  // Redireciona via breadcrumb
  private beforeRedirect(itemBreadcrumbLabel) {
    if (this.formEdit.valid) {
      this.route.navigate(['/']);
    } else {
      this.poDialog.confirm({
        title: `Confirma o redirecionamento para ${itemBreadcrumbLabel}`,
        message: `Existem dados que não foram salvos ainda. Você tem certeza que quer sair ?`,
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
        this.poNotification.success('Idioma alterado com sucesso');
        this.showLoading = false;
        this.route.navigate(['/idiomas']);
      });
    } else {
      // Cria um registro novo
      this.service.create(this.record).subscribe(resp => {
        this.poNotification.success('Idioma criado com sucesso');
        this.showLoading = false;
        this.route.navigate(['/idiomas']);
      });
    }
  }

  // Cancela a edicao e redireciona ao clicar no botao Cancelar
  public cancelClick(): void {
    this.poDialog.confirm({
      title: 'Confirma cancelamento',
      message: 'Existem dados que não foram salvos ainda. Você tem certeza que quer cancelar ?',
      confirm: () => this.route.navigate(['/'])
    });
  }
}
