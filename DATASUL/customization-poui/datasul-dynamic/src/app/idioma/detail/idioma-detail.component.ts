import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { PoBreadcrumb } from '@po-ui/ng-components';

import { IdiomaService } from './../resources/idioma.service';

@Component({
  selector: 'app-idioma-detail',
  templateUrl: './idioma-detail.component.html',
  styleUrls: ['./idioma-detail.component.css']
})

export class IdiomaDetailComponent implements OnInit {
  // definicao das variaveis utilizadas
  public cTitle = 'Detalhe do Idioma';
  public currentId: string;
  public fields: Array<any> = [];
  public record = {};
  public showLoading = false;

  public readonly breadcrumb: PoBreadcrumb = { items: [
      { label: 'Home', link: '/' },
      { label: 'Idiomas', link: '/idiomas' },
      { label: 'Detail' } ]
  };

  // construtor com os servicos necessarios
  constructor(
    private service: IdiomaService,
    private activatedRoute: ActivatedRoute,
    private route: Router
  ) { }

  // load do componente
  public ngOnInit(): void {
    this.activatedRoute.params.subscribe(pars => {
      this.showLoading = true;

      // carrega o registro pelo ID
      this.currentId = pars['id'];
      this.service.getById(this.currentId).subscribe(resp => {
        Object.keys(resp).forEach((key) => this.record[key] = resp[key]);

        // carrega a lista de campos somente apos receber o registro a ser apresentado
        this.fields = this.service.getFieldList(false);
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
