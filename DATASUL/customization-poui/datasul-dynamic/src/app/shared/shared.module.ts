import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { PoModule } from '@po-ui/ng-components';
import { PoTemplatesModule } from '@po-ui/ng-templates';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,

    PoModule,
    HttpClientModule,
    PoTemplatesModule,
  ],
  exports: [
    CommonModule,
    FormsModule,

    PoModule,
    HttpClientModule,
    PoTemplatesModule
  ]
})
export class SharedModule { }
