package com.word;

public class TestWord {

	public static void main(String[] args) throws Exception{
		new CreateWordDocument().run();
		new ReadWordText().run();
		new CreateImageWord().run();
		new ChangeFormVariables().run();
		new ChangeFormFields().run();
	}
}
