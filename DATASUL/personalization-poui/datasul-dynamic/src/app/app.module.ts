import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouterModule } from '@angular/router';
import { PoLoadingModule, PoModule } from '@po-ui/ng-components';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { SharedModule } from './shared/shared.module';
import { PersonalizationComponent } from './personalization/personalization.component';

@NgModule({
  declarations: [
    AppComponent,
    PersonalizationComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    SharedModule,
    PoLoadingModule,
    RouterModule.forRoot([]),
    PoModule
  ],
  providers: [
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
