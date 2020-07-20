import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouterModule } from '@angular/router';
import { PoLoadingModule, PoI18nConfig, PoI18nModule, PoModule } from '@po-ui/ng-components';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { IdiomaDetailComponent } from './idioma/detail/idioma-detail.component';
import { IdiomaEditComponent } from './idioma/edit/idioma-edit.component';
import { IdiomaListComponent } from './idioma/list/idioma-list.component';
import { IdiomaService } from './idioma/resources/idioma.service';
import { SharedModule } from './shared/shared.module';
import { generalPt } from './i18n/general-pt';
import { generalEn } from './i18n/general-en';

const i18nConfig: PoI18nConfig = {
  default: {
    language: 'pt-BR',
    context: 'general',
    cache: false
  },
  contexts: {
    general: {
      'pt-BR': generalPt,
      'en-US': generalEn,
      url: 'api/trn/v1/idiomas/translations'
    }
  }
};

@NgModule({
  declarations: [
    AppComponent,
    IdiomaDetailComponent,
    IdiomaEditComponent,
    IdiomaListComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    SharedModule,
    PoLoadingModule,
    RouterModule.forRoot([]),
    PoModule,
    PoI18nModule.config(i18nConfig)
  ],
  providers: [IdiomaService],
  bootstrap: [AppComponent]
})
export class AppModule { }
